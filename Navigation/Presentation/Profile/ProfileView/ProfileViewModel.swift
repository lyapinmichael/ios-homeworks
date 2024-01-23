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
        case .didTapPrintStatusButton(let status):
            state = .printStatus(status)
        case .didTapSetStatusButton(let status):
            firestoreService.writeUserDocument(user) {
                print("User document updated successfully")
            }
            state = .setStatus(status)
        case .didTapLogOutButton:
            coordinator?.logOut()
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
    
    //MARK: Enums
    
    /// Possible states
    enum State {
        case initial
        case printStatus(String)
        case setStatus(String)
        case didReceiveUserData
    }
    
    /// Possible input actions performed by user
    enum ViewInput {
        case didTapPrintStatusButton(String)
        case didTapSetStatusButton(String)
        case didTapLogOutButton
        case didFinishUpdatingUI
    }
   
}

extension ProfileViewModel: EditProfileViewModelDelegate {
    func editProfileViewModel(_ editProfileViewModel: EditProfileViewModel, didUpdateDispalyName newName: String) {
        self.repository.profileData.value.fullName = newName
        self.state = .didReceiveUserData
    }
    
    
}

