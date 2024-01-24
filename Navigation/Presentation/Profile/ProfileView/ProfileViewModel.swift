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
    
    let repository: ProfileRepository
    
    // MARK: - Private properties
    
    private let firestoreService = FirestoreService()
    
    // MARK: - Init
    
    init(repository: ProfileRepository) {
        self.repository = repository
        fetchPostData()
        bindObservables()
    }
    
    // MARK: - Public methods
    
    func updateState(withInput input: ViewInput) {
        switch input {
        case .didFinishUpdatingUI:
            state = .initial
        case .didTapLogOutButton:
            coordinator?.logOut()
        case .deletePost(let post):
            delete(post)
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
    
    private func delete(_ post: Post) {
        state = .waiting
        firestoreService.deletePost(post) { [weak self] error in
            if let error {
                self?.state = .failedToDeletePost
            } else {
                do {
                    try self?.repository.delete(post)
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
    }
    
    /// Possible input actions performed by user
    enum ViewInput {
        case didTapLogOutButton
        case didFinishUpdatingUI
        case deletePost(Post)
    }
   
}

extension ProfileViewModel: EditProfileViewModelDelegate {
    func editProfileViewModel(_ editProfileViewModel: EditProfileViewModel, didUpdateDispalyName newName: String) {
        self.repository.profileData.value.fullName = newName
        self.state = .didReceiveUserData
    }
    
    
}

