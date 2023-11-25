//
//  SignInFlow.swift
//  Navigation
//
//  Created by Ляпин Михаил on 20.11.2023.
//

import Foundation

final class SignInViewModel {
    
    // MARK: State relate properties
    
    private(set) var state: State = .waitingForEmail {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    // MARK: Private properties
    
    private var email: String = ""
    private var password: String = ""
    
    // MARK: Public methods
    
    func updateState(with viewInput: ViewInput) {
       
        switch viewInput {
        case .didTapContinueButton:
            if case .waitingForEmail = state {
                checkEmailFormat()
                break
            }
            
            if case .waitigForPassword = state {
                state = .trySignIn(email, password)
            }
            
        case .didTapReturnToEmailButton:
            state = .waitingForEmail
            
        case .didTapCloseAlert:
            state = .waitingForEmail
            
        case .didChangeEmailEditing(let email):
            self.email = email
            
        case .didChangePasswordEditing(let password):
            self.password = password
        }
        
    }
    
    // MARKL Private methods
    
    private func checkEmailFormat() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if emailPredicate.evaluate(with: email) {
            self.state = .waitigForPassword
        } else {
            self.state = .emailFormatInvalid
        }

    }
    
    // MARK: Types
    
    enum State {
        case waitingForEmail
        case emailFormatInvalid
        case waitigForPassword
        case wrongPassword
        case trySignIn(String, String)
    }
    
    enum ViewInput {
        case didTapContinueButton
        case didTapReturnToEmailButton
        case didTapCloseAlert
        case didChangeEmailEditing(String)
        case didChangePasswordEditing(String)
    }
    
    
}
