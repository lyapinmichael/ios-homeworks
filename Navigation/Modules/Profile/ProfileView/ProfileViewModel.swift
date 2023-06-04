//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 25.04.2023.
//

import Foundation
import StorageService

protocol ProfileViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((ProfileViewModel.State) -> Void)? { get set }
    var user: User { get }
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
    }
    
    /// Possible input actions performed by user
    enum ViewInput {
        case didTapPrintStatusButton(String)
        case didTapSetStatusButton(String)
    }
    
    // MARK: - Private properties
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    // MARK: - Public properties
    
    ///Coordinator
    weak var coordinator: ProfileCoordinator?
    
    var onStateDidChange: ((State) -> Void)?
    
    var user: User
    var postData = Post.make()
    
    // MARK: - Init
    init(withUser user: User) {
        self.user = user
    }
    
    
    // MARK: - Public methods
    
    func updateState(withInput input: ViewInput) {
        switch input {
        case let .didTapPrintStatusButton(status):
            state = .printStatus(status)
        case let .didTapSetStatusButton(status):
            state = .setStatus(status)
        }
    }
}

