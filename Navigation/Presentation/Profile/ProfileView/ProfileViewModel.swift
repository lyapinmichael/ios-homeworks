//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 25.04.2023.
//

import Foundation
import StorageService
import FirebaseAuth

protocol ProfileViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((ProfileViewModel.State) -> Void)? { get set }
    var user: User { get set }
    var postData: [Post] { get }
    
    func updateState(withInput input: ProfileViewModel.ViewInput)
    
}


final class ProfileViewModel: ProfileViewModelProtocol {
    
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
    }
    
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
    
    var user: User
    
    var postData: [Post] = [] {
        didSet {
            postData.sort(by: { $0.dateCreated.dateValue() > $1.dateCreated.dateValue() })
        }
    }
    
    // MARK: - Private properties
    
    private let firestoreService = FirestoreService()
    
    // MARK: - Init
    init(withUser user: User) {
        
        self.user = user
        
        self.fetchUserData()
        self.fetchPostData()
    }
    
    // MARK: - Public methods
    
    func updateState(withInput input: ViewInput) {
        switch input {
        case let .didTapPrintStatusButton(status):
            state = .printStatus(status)
        case let .didTapSetStatusButton(status):
            user.status = status
            firestoreService.writeUserDocument(user) {
                print("User document updated successfully")
            }
            state = .setStatus(status)
        case .didTapLogOutButton:
            coordinator?.logOut()
        }
    }
    
    // MARK: - Private methods
    
    private func fetchUserData() {
        firestoreService.fetchUserData(userID: user.id) { [weak self] result in
            
            guard let self else { return }
            
            switch result {
            case .success(let user):
                self.user = user
                self.fetchPostData()
            
            case .failure(let error):
                if case .userDocumentDoesntExist = error {
                    self.firestoreService.writeUserDocument(user) {
                        
                        // TODO: make some logic here
                        print("New user document successfully created in database")
                    }
                } else {
                    print(error)
                }
            }
        }
        
    }
    
    private func fetchPostData() {
        Task {
            let posts = try await firestoreService.fetchPostData(by: user.id)
            DispatchQueue.main.async {
                self.postData = posts
                self.state = .didReceiveUserData
            }
        }
    }
    
   
}

