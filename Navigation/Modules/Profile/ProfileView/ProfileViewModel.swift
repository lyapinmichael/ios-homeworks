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
    var postData: [(`post`: Post, imageData: Data?)] { get }
    
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
    
    ///Coordinator
    weak var coordinator: ProfileCoordinator?
    
    var user: User {
        didSet {
            cloudStorageService.userID = user.id
        }
    }
    var postData: [(`post`: Post, imageData: Data?)] = []
    
    // MARK: - Private properties
    
    private let firestoreService: FirestoreService
    private let cloudStorageService = CloudStorageService()
    
    // MARK: - Init
    init(withUser user: User) {
        
        self.user = user
        
        firestoreService = FirestoreService(userID: user.id)
        
        firestoreService.fetchUserData { [weak self] result in
            
            guard let self else { return }
            
            switch result {
            case .success(let user):
                self.user = user
                self.postData = user.posts.compactMap { ($0, nil)}
                self.state = .didReceiveUserData
                
                for (index, post) in postData.enumerated() {
                    do {
                        let imageData = try CacheService.default.readPostImageCache(from: post.post.id)
                        self.postData[index].imageData = imageData
                        DispatchQueue.main.async {
                            self.state = .didReceiveUserData
                        }
                    } catch {
                        if case CacheService.CacheServiceError.fileDoesntExists = error {
                            self.getImage(for: post.post.id)
                        }
                    }
                }
                
                
            case .failure(let error):
                
                if case .userDocumnentDoesntExist = error {
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
    
    private func getImage(for postID: String) {
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        cloudStorageService.downloadImage(forPost: postID) { [weak self] imageData, error in
            guard let self else { return }
            
            if let error {
                return
            }
            
            
            if let imageData,
               let index = postData.firstIndex(where: { $0.post.id == postID} ) {
                self.postData[index].imageData = imageData
                do {
                    try CacheService.default.writePostImageCache(from: (postID, imageData))
                } catch {
                    print("=====\nError occured while trying to save image to file:\n\(error)\n=====")
                }
            }
        
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.state = .didReceiveUserData
        }
    }
}

