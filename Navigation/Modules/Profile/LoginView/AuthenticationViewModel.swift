//
//  LoginViewModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 16.10.2023.
//

import Foundation

final class AuthenticationViewModel {
    
    // MARK: - Enums for state and view input
    
    enum State {
        case initial
        case didLogIn(userID: String)
        case failedToLogIn(Error)
        case didSignUp(userID: String)
        case failedToSignUp(Error)
    }
    
    enum ViewInput {
        case tryLogIn(login: String, password: String)
        case trySignUp(login: String, password: String, fullName: String)
    }
    
    // MARK: - State related properties
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    // MARK: - Private properties
    
    private var authenticationService: AuthenticationDelegate = AuthenticationService()
    
    // MARK: - State related method
    
    func updateState(with viewInput: ViewInput) {
        switch viewInput {
        case .tryLogIn(let login, let password):
            self.logIn(login: login, password: password)
        case .trySignUp(let login, let password, let fullName):
            self.signUp(login: login, password: password, fullName: fullName)
        }
    }
    
    // MARK: - Private methods
    
    private func logIn(login: String, password: String) {
       
        authenticationService.logIn(email: login, password: password) { [weak self] result in
            
            switch result {
            case .success(let userID):
                self?.state = .didLogIn(userID: userID)
                
            case .failure(let error):
                self?.state = .failedToLogIn(error)
            }
        }
    }
    
    private func signUp(login: String, password: String, fullName: String) {
        
        authenticationService.signUp(email: login,
                                     password: password,
                                     fullName: fullName) { [weak self] result in
            
            switch result {
            case .success(let userID):
                self?.state = .didSignUp(userID: userID)
                
            case .failure(let error):
                self?.state = .failedToSignUp(error)
            }
            
        }
    }
}
