//
//  LoginInspector.swift
//  Navigation
//
//  Created by Ляпин Михаил on 15.04.2023.
//

import Foundation
import FirebaseAuth


//MARK: - LogInViewControllerDelegate Protocol

protocol AuthenticationDelegate: AnyObject {
    
    func logIn(email: String, password: String, completion: @escaping ((Result<String, AuthenticationService.AuthenticationErrors>) -> Void))
    func signUp(email: String, password: String, fullName: String, completion: @escaping ((Result<String, AuthenticationService.AuthenticationErrors>) -> Void))
    func signOut()
}

class AuthenticationService: AuthenticationDelegate {
    
    enum AuthenticationErrors: Error {

        case loginNotRegistered(errorMessage: String)
        case wrongLoginOrPassword
        case emptyLogin
        case emptyPassword
        case authResultIsNil
        case credentialsCheckFailure
        case failedToSignUp
        
    }
    
   
    
    func logIn(email: String, password: String, completion: @escaping ((Result<String, AuthenticationErrors>) -> Void)) {
        
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            
            if let error {
                completion(.failure(.credentialsCheckFailure))
                return
            }
            
            guard let result = authResult else {
                completion(.failure(.authResultIsNil))
                return
            }
            
            
            completion(.success((result.user.uid)))
        }
       
    }
    
    func signUp(email: String, password: String, fullName: String, completion: @escaping ((Result<String, AuthenticationErrors>) -> Void)) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error {
                completion(.failure(.failedToSignUp))
                print(error)

                return
            }
            
            // Firstly, a password-based user is created, and logged into
            // It's important, that it's type is AuthDataResult, which cannot
            // be modified, so we its .user property of type User, so we can
            // modify it's fields, namely displayName, which we want to pass
            // fullName parameter to
            guard let user  = authResult?.user else {
                completion(.failure(.authResultIsNil))
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
            
            completion(.success(user.uid))
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        
    }
}
