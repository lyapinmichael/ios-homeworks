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
    
    func signIn(email: String, password: String, completion: @escaping ((Result<User, AuthenticationService.AuthenticationError>) -> Void))
    func signUp(email: String, password: String, fullName: String, completion: @escaping ((Result<User, AuthenticationService.AuthenticationError>) -> Void))
    func checkIfUserNotExists(email: String, completion: @escaping (Result<String, AuthenticationService.AuthenticationError>) -> Void)
    func signOut()
}

class AuthenticationService: AuthenticationDelegate {
        
    // MARK: Private propeties
    
    private let auth = Auth.auth()
    
    // MARK: Public methods
    
    func signIn(email: String, password: String, completion: @escaping ((Result<User, AuthenticationError>) -> Void)) {
        
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            
            if let error {
                completion(.failure(.credentialsCheckFailure))
                return
            }
            
            guard let authUser = authResult?.user,
                  let login = authUser.email,
                  let fullName = authUser.displayName
            else {
                completion(.failure(.authResultIsNil))
                return
            }
            
            let id = authUser.uid
            
            let user = User(id: id,
                            login: login,
                            fullName: fullName)
            
            completion(.success((user)))
        }
       
    }
    
    func signUp(email: String, password: String, fullName: String, completion: @escaping ((Result<User, AuthenticationError>) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error {
                completion(.failure(.failedToSignUp))
                print(error)
                
                return
            }
            
            /// Firstly, a password-based user is created, and logged into
            /// It's important, that it's type is AuthDataResult, which cannot
            /// be modified, so we its .user property of type User, so we can
            /// modify it's fields, namely displayName, which we want to pass
            /// fullName parameter to
            guard let authUser  = authResult?.user,
                  let login = authUser.email
            else {
                completion(.failure(.authResultIsNil))
                return
            }
            
            /// Secondly, we make a request to change profile, then perform changes.
            let changeRequest = authUser.createProfileChangeRequest()
            changeRequest.displayName = fullName
            
            /// And finally commit the changes.
            changeRequest.commitChanges() { error in
                guard error != nil else { return }
                completion(.failure(.failedToSignUp))
            }
            
            let user = User(id: authUser.uid,
                            login: login,
                            fullName: fullName)
            
            FirestoreService().writeUserDocument(user) { error in
                if let error {
                    completion(.failure(.failedToSignUp))
                } else {
                    completion(.success(user))
                }
            }
        }
    }
    
    func checkIfUserNotExists(email: String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        /// If a user with passed email is already registered to firebase,
        /// `auth.fetchSignInMethods(forEmail:completion:)` will have `signInMethods`
        /// not nil (presumably `["password"]`, as for now Firebase project only
        /// suppors registration view email-password pair. If so, completion with
        /// error `.emailAlreadyExist` is called, else completion is called with
        /// success and email passed to it.
        
        auth.fetchSignInMethods(forEmail: email) { signInMethods, error in
            if let error {
                print(error)
                completion(.failure(.failedToChechIfEmailIsRegistered))
            }
            
            if let signInMethods {
                completion(.failure(.emailAlreadyExists))
            } else {
                completion(.success(email))
            }
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        
    }
    
    // MARK: Types
    
    enum AuthenticationError: Error {

        case loginNotRegistered(errorMessage: String)
        case wrongLoginOrPassword
        case emptyLogin
        case emptyPassword
        case authResultIsNil
        case credentialsCheckFailure
        case failedToSignUp
        case failedToChechIfEmailIsRegistered
        case emailAlreadyExists
        
    }
    
    
}
