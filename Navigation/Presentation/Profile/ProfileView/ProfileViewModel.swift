//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 25.04.2023.
//

import Foundation
import StorageService
import FirebaseAuth

protocol ProfileViewModelProtocol: ViewModelProtocol, EditProfileViewModelDelegate {
    var onStateDidChange: ((ProfileViewModel.State) -> Void)? { get set }
    var postData: [Post] { get }
    var user: User { get }
    var avatar: UIImage? { get }
    var repository: ProfileRepository { get }
    
    func updateState(withInput input: ProfileViewModel.ViewInput)
    
}


final class ProfileViewModel: ProfileViewModelProtocol {
    
    // MARK: - State related properties
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    // MARK: - Public properties
    
    //Coordinator
    weak var coordinator: ProfileCoordinator?
    
    var user: User {
        return repository.profileData.value
    }
    
    var postData: [Post] {
        get {
            return repository.postData.value.sorted(by: { $0.dateCreated.dateValue() > $1.dateCreated.dateValue() })
        }
        set {
            repository.postData.value = newValue
        }
    }
    
    var avatar: UIImage? {
        didSet {
            state = .didReceiveUserData
        }
    }
    
    let repository: ProfileRepository
    
    // MARK: - Private properties
    
    private let firestoreService = FirestoreService()
    
    // MARK: - Init
    
    init(repository: ProfileRepository) {
        self.repository = repository
        fetchPostData()
        fetchAvatar()
        bindObservables()
    }
    
    // MARK: - Public methods
    
    func updateState(withInput input: ViewInput) {
        switch input {
        case .didFinishUpdatingUI:
            state = .initial
        case .didTapLogOutButton:
            coordinator?.logOut()
        case .didTapChangeAvatarButton:
            state = .presentImagePicker
        case .deletePost(let post):
            delete(post)
        case .didFinishPickingAvatar(let image):
            changeAvatar(image)
        case .didTapDeleteAvatarButton:
            deleteAvatar()
        }
    }
    
    // MARK: - Private methods
    
    private func bindObservables() {
        repository.profileData.bind { _ in
            DispatchQueue.main.async {
                self.state = .didReceiveUserData
            }
        }
        repository.postsCount.bind { _ in
            DispatchQueue.main.async {
                self.state = .didReceiveUserData
            }
        }
        repository.postData.bind { _ in
            self.state = .didReceiveUserData
        }
    }
    
    private func fetchAvatar() {
        guard user.hasAvatar else { return }
        if let imageNSData = repository.imageCache.object(forKey: NSString(string:  user.id)),
           let avatar = UIImage(data: Data(referencing: imageNSData)) {
            self.avatar = avatar
        } else {
            do {
                let imageData = try LocalStorageService.default.readUserAvatarCache(from: user.id)
                if let image = UIImage(data: imageData) {
                    avatar = image
                }
                repository.imageCache.setObject(NSData(data: imageData),
                                                     forKey: NSString(string: user.id))
            } catch {
                CloudStorageService.shared.downloadAvatar(forUser: user.id) { [weak self] imageData, error in
                    guard let self else { return }
                    if error != nil  {
                        return
                    }
                    if let  imageData,
                       let image = UIImage(data: imageData),
                       let imageData = image.jpegData(compressionQuality: 0.8) {
                        try? LocalStorageService.default.writeUserAvatarCache(userID: self.user.id,
                                                                         jpegData: imageData)
                        self.repository.imageCache.setObject(NSData(data: imageData),
                                                             forKey: NSString(string: self.user.id))
                        self.avatar = image
                    }
                }
            }
        }
    }
    
    private func changeAvatar(_ image: UIImage) {
        CloudStorageService.shared.uploadAvatar(image, forUser: user.id) { [weak self] error in
            guard let self else { return }
            if error != nil {
                self.state = .failedToUploadAvatar
                return
            }
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
            let imageNSData = NSData(data: imageData)
            let userIDNSString = NSString(string: user.id)
            repository.imageCache.setObject(imageNSData, forKey: userIDNSString)
            avatar = image
            try? LocalStorageService.default.writeUserAvatarCache(userID: user.id, jpegData: imageData)
        }
    }
    
    private func fetchPostData() {
        Task {
            let posts = try await firestoreService.fetchPostData(by: user.id)
            DispatchQueue.main.async {
                self.postData = posts
                self.repository.postsCount.value = posts.count
                self.state = .didReceiveUserData
            }
        }
    }
    
    private func deleteAvatar() {
        state = .waiting
        CloudStorageService.shared.deleteAvatar(forUser: user.id) { [weak self] error in
            guard let self else { return }
            if let error {
                self.state = .failedToUploadAvatar
            } else {
                self.avatar = nil
                let userIDNSString = NSString(string: self.user.id)
                self.repository.imageCache.removeObject(forKey: userIDNSString)
                do {
                    try LocalStorageService.default.deleteUserAvatarCache(from: self.user.id)
                } catch {
                    print(">>>>>\t", error)
                }
            }
        }
    }
    
    private func delete(_ post: Post) {
        state = .waiting
        firestoreService.deletePost(post) { [weak self] error in
            if let error {
                print(">>>>>\t", error)
                self?.state = .failedToDeletePost
            } else {
                do {
                    try self?.repository.delete(post)
                    try LocalStorageService.default.deletePostImageCache(from: post.id ?? "")
                } catch {
                    print(">>>>>\t", error)
                    self?.fetchPostData()
                }
                self?.state = .postDeletedSuccessfully
            }
        }
        CloudStorageService.shared.deleteImage(forPost: post)
    }
    
    //MARK: Enums
    
    /// Possible states
    enum State {
        case initial
        case didReceiveUserData
        case waiting
        case failedToDeletePost
        case postDeletedSuccessfully
        case presentImagePicker
        case failedToUploadAvatar
    }
    
    /// Possible input actions performed by user
    enum ViewInput {
        case didTapLogOutButton
        case didFinishUpdatingUI
        case deletePost(Post)
        case didTapChangeAvatarButton
        case didFinishPickingAvatar(UIImage)
        case didTapDeleteAvatarButton
    }
  
    
}

extension ProfileViewModel: EditProfileViewModelDelegate {
    func editProfileViewModel(_ editProfileViewModel: EditProfileViewModel, didUpdateDispalyName newName: String) {
        self.repository.profileData.value.fullName = newName
        self.state = .didReceiveUserData
    }
    
    
}
