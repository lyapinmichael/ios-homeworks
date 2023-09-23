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
    
    func checkCredentials(email: String, password: String, completion: @escaping ((Result<(String?, String?), LoginInspectorErrors>) -> Void))
    func signUp(email: String, password: String, fullName: String, completion: @escaping ((Result<String?, LoginInspectorErrors>) -> Void))
    func signOut()
}

enum LoginInspectorState: Equatable {
    case didLogin(Bool)
    case didSignUp(Bool)
}

class LoginInspector: LogInViewControllerDelegate {
    
    typealias State = LoginInspectorState
    
    private(set) var state: State = .didLogin(false)
    
    func checkCredentials(email: String, password: String, completion: @escaping ((Result<(String?, String?), LoginInspectorErrors>) -> Void)) {
        CheckerService().checkCredentials(email: email, password: password) { result in 
            completion(result)
        }
    }
    
    func signUp(email: String, password: String, fullName: String, completion: @escaping ((Result<String?, LoginInspectorErrors>) -> Void)) {
        CheckerService().signUp(email: email, password: password) { result in
            
            if case .success = result {
                let user = Auth.auth().currentUser
                let changeRequest = user?.createProfileChangeRequest()
                changeRequest?.displayName = fullName
                
                changeRequest?.commitChanges() { error in
                    guard error != nil else { return }
                    completion(.failure(.failedToSignUp))
                }
                
                completion(.success(user?.email))
            } else {
                completion(.failure(.failedToSignUp))
            }
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        
    }
}
