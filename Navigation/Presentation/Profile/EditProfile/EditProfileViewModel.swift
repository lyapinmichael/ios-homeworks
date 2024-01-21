//
//  EditProfileViewModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 05.12.2023.
//

import Foundation

protocol EditProfileViewModelDelegate: AnyObject {
    func editProfileViewModel(_ editProfileViewModel: EditProfileViewModel, didUpdateDispalyName newName: String)
}

final class EditProfileViewModel {
    
    // MARK: Public properties
    
    weak var delegate: EditProfileViewModelDelegate?
    
    var user: User {
        return repository.profileData.value
    }
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    // MARK: Private properties
    
    private let firestoreService = FirestoreService()
    private let repository: ProfileRepository
    
    // MARK: Init
    
    init(repository: ProfileRepository) {
        self.repository = repository
    }
    
    // MARK: Public methods
    
    func updateState(with viewInput: ViewInput) {
        switch viewInput {
        case .didTapDoneButton(let newName):
            state = .tryCommitEdit
            commitEdit(newName: newName)
        }
    }
    
    // MARK: Private methods
    
    private func commitEdit(newName: String?) {
        
        guard let newName,
              !newName.isEmpty,
              !newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            state = .failedToCommitEdit
            return
        }
        
        firestoreService.updateUserDisplayName(user, updatedName: newName) { [weak self] error in
           guard let self else { return }
            if let error {
                self.state = .failedToCommitEdit
                print(error)
            } else {
                self.state = .editCommited
                delegate?.editProfileViewModel(self, didUpdateDispalyName: newName)
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
