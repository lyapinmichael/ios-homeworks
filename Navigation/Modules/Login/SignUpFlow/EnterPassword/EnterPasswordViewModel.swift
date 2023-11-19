//
//  EnterPasswordViewModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 16.11.2023.
//

import Foundation

// MARK: EnterPasswordViewModel

final class EnterPasswordViewModel {
    
    // MARK: - State relied properties
    
    private(set) var state: State = .waitingForPassword {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    // MARK: Private properties
    
    private var password: String? = nil
    
    // MARK: Public methods
    
    func updateState(with viewInput: ViewInput) {
        
        switch viewInput {
        case .passwordDidChangeEnditing(let password):
               checkLength(of: password)
            
            
        case .repeatPasswordDidChangeEnditing(let password):
            guard let checkPassword = self.password,
                  let newPassword = password else { return }
            state = .waitingToComparePasswords(checkPassword, newPassword)
            
        case .buttonDidTap:
            if case .passwordLegthValid(let password) = state {
                checkForWhiteSpaces(password)
            }
            
            if case .passwordsDoNotMatch = state {
                state = .waitingForPassword
            }
            
            if case .waitingToComparePasswords(let checkPassword, let newPassword) = state {
                compare(checkPassword, with: newPassword)
            }

        
        case .alertButtonDidTap:
            state = .waitingForPassword
        }
    }
    
    // MARK: Private methods
    
    private func checkLength(of string: String?) {
        
        if let password = string,
           password.count >= 6 {
            self.state = .passwordLegthValid(password)
        } else {
            self.state = .passwordTooShort
        }
    }
    
    private func checkForWhiteSpaces(_ string: String) {
        
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        
        if let _ = string.rangeOfCharacter(from: whitespace) {
            state = .passwordContainsWhitespaces
        } else {
            self.password = string
            state = .waitingToRepeatPassword
        }
    }
    
    private func compare(_ checkPassword: String, with newPassword: String) {
        
        if checkPassword == newPassword {
            self.state = .passwordsValidAndMatch(checkPassword)
        } else {
            self.password = nil
            self.state = .passwordsDoNotMatch
        }
        
    }
    
    // MARK: Types
    
    enum State {
        case waitingForPassword
        case waitingToRepeatPassword
        case passwordContainsWhitespaces
        case passwordTooShort
        case passwordLegthValid(String)
        case passwordsDoNotMatch
        case passwordsValidAndMatch(String)
        case waitingToComparePasswords(String, String)
        
    }
    
    enum ViewInput {
        case passwordDidChangeEnditing(String?)
        case repeatPasswordDidChangeEnditing(String?)
        case buttonDidTap
        case alertButtonDidTap
    }
    
}
