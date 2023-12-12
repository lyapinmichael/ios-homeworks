//
//  EditProfileViewModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 05.12.2023.
//

import Foundation

final class EditProfileViewModel {
    
    // MARK: Public properties
    
    var user: User
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    // MARK: Private properties
    
    private let firestoreService = FirestoreService()
    
    // MARK: Init
    
    init(_ user: User) {
        self.user = user
    }
    
    // MARK: Public methods
    
    func updateState(with viewInput: ViewInput) {
        switch viewInput {
        case .didTapDoneButton(let newName):
            state = .tryCommitEdit
            commitEdit(newName: newName)
        }
    }
    
    private func commitEdit(newName: String?) {
        
        guard let newName,
              !newName.isEmpty,
              !newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            state = .failedToCommitEdit
            return
        }
        
        firestoreService.updateUserDisplayName(user, updatedName: newName) { [weak self] error in
            if let error {
                self?.state = .failedToCommitEdit
                print(error)
            } else {
                self?.state = .editCommited
            }
        }
        
    }
    
    // MARK: Types
    
    enum State {
        case initial
        case tryCommitEdit
        case failedToCommitEdit
        case editCommited
    }
    
    enum ViewInput {
        case didTapDoneButton(String?)
    }
    
}
