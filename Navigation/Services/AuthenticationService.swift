//
//  LoginInspector.swift
//  Navigation
//
//  Created by Ляпин Михаил on 15.04.2023.
//

import Foundation
import FirebaseAuth

enum LoginInspectorErrors: Error {

    case loginNotRegistered(errorMessage: String)
    case wrongLoginOrPassword
    case emptyLogin
    case emptyPassword
    case authResultIsNil
    case credentialsCheckFailure
    case failedToSignUp
    
}

//MARK: - LogInViewControllerDelegate Protocol

protocol LogInViewControllerDelegate: AnyObject {
    
    var state: LoginInspectorState { get }
    
    var userID: String?  { get }
    
    func logIn(email: String, password: String, completion: @escaping ((Result<(String?, String?), LoginInspectorErrors>) -> Void))
    func signUp(email: String, password: String, fullName: String, completion: @escaping ((Result<String?, LoginInspectorErrors>) -> Void))
    func signOut()
}

enum LoginInspectorState: Equatable {
    case didLogin(Bool)
    case didSignUp(Bool)
}

class AuthenticationService: LogInViewControllerDelegate {
    
    // This property is crucial for further work with firestore.
    // It is received whenever user logs in, so the app knows user identity,
    // and knowing user's identity the app then makes queries into Cloud Firestore
    // to read and write user-specific data, such as posts.
    var userID: String?
    
    typealias State = LoginInspectorState
    
    private(set) var state: State = .didLogin(false)
    
    func logIn(email: String, password: String, completion: @escaping ((Result<(String?, String?), LoginInspectorErrors>) -> Void)) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            if let error {
                completion(.failure(.credentialsCheckFailure))
                return
            }
            
            guard let result = authResult else {
                completion(.failure(LoginInspectorErrors.authResultIsNil))
                return
            }
            
            self?.userID = result.user.uid
            completion(.success((result.user.email, result.user.displayName)))
        }
       
    }
    
    func signUp(email: String, password: String, fullName: String, completion: @escaping ((Result<String?, LoginInspectorErrors>) -> Void)) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error {
                completion(.failure(.failedToSignUp))

                return
            }
            
            // Firstly, a password-based user is created, and logged into
            // It's important, that it's type is AuthDataResult, which cannot
            // be modified, so we its .user property of type User, so we can
            // modify it's fields, namely displayName, which we want to pass
            // fullName parameter to
            guard let user  = authResult?.user else {
                completion(.failure(LoginInspectorErrors.authResultIsNil))
                return
            }
            

            // Secondly, we make a request to change profile, then perform changes.
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = fullName
            
            // And finally commit the changes.
            changeRequest.commitChanges() { error in
                guard error != nil else { return }
                completion(.failure(.failedToSignUp))
            }
            
            completion(.success(user.email))
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        
    }
}
