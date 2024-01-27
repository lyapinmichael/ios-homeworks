//
//  LoginViewModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 16.10.2023.
//

import Foundation
import FirebaseAuth

final class AuthenticationViewModel {
    
    
    // MARK: - State related properties
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    // MARK: - Private properties
    
    private var authenticationService: AuthenticationProtocol = AuthenticationService()
    
    // MARK: - State related method
    
    func updateState(with viewInput: ViewInput,  completion: @escaping ()-> Void = {}) {
        switch viewInput {
        case .trySignIn(let login, let password):
            self.signIn(login: login, password: password)
            
        case .trySignUp(let login, let password, let fullName):
            self.signUp(login: login, password: password, fullName: fullName)
            
        case .checkNotExists(let email):
            self.checkEmailNotExists(email: email) { 
                completion()
            }
            
        }
    }
    
    // MARK: - Private methods
    
    private func signIn(login: String, password: String, failureHandler: @escaping () -> Void = {}) {
       
        authenticationService.signIn(email: login, password: password) { [weak self] result in
            
            switch result {
            case .success(let user):
                self?.state = .didLogIn(user)
                
            case .failure(let error):
                self?.state = .failedToLogIn(error)
                failureHandler()
            }
        }
    }
    
    private func signUp(login: String, password: String, fullName: String) {
        
        authenticationService.signUp(email: login,
                                     password: password,
                                     fullName: fullName) { [weak self] result in
            
            switch result {
            case .success(let user):
                self?.state = .didSignUp(user)
                
            case .failure(let error):
                self?.state = .failedToSignUp(error)
            }
        }
    }
    
    private func checkEmailNotExists(email: String, completion: @escaping () -> Void) {
        
        authenticationService.checkIfUserNotExists(email: email) { [weak self] result in
        
            switch result {
            case .success:
                completion()
                
            case .failure(let error):
                if case .emailAlreadyExists = error {
                    self?.state = .emailAlreadyExists(email)
                }
            }
        }
    }
    
    // MARK: - Types
    
    enum State {
        case initial
        case didLogIn(User)
        case failedToLogIn(Error)
        case emailAlreadyExists(String)
        case didSignUp(User)
        case failedToSignUp(Error)
    }
    
    enum ViewInput {
        case trySignIn(login: String, password: String)
        case trySignUp(login: String, password: String, fullName: String)
        case checkNotExists(email: String)
    }
    
    
}
