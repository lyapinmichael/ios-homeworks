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
    
}

//MARK: - LogInViewControllerDelegate Protocol

protocol LogInViewControllerDelegate: AnyObject {
    
    func checkCredentials(email: String, password: String, completion: @escaping ((Result<AuthDataResult, Error>) -> Void))
    func signUp(email: String, password: String, fullName: String, completion: @escaping ((Result<AuthDataResult, Error>) -> Void))
    func signOut()
}

class LoginInspector: LogInViewControllerDelegate {
    
    func checkCredentials(email: String, password: String, completion: @escaping ((Result<AuthDataResult, Error>) -> Void)) {
        CheckerService().checkCredentials(email: email, password: password) { result in 
            completion(result)
        }
    }
    
    func signUp(email: String, password: String, fullName: String, completion: @escaping ((Result<AuthDataResult, Error>) -> Void)) {
        CheckerService().signUp(email: email, password: password) { result in
            
            if case .success = result {
                let user = Auth.auth().currentUser
                let changeRequest = user?.createProfileChangeRequest()
                changeRequest?.displayName = fullName
                
                changeRequest?.commitChanges() { error in
                    guard error != nil else { return }
                    completion(.failure(error!))
                }
            }
            
            completion(result)
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        
    }
}
