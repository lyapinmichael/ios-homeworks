//
//  CheckerService.swift
//  Navigation
//
//  Created by Ляпин Михаил on 06.06.2023.
//

import Foundation
import FirebaseAuth


protocol CheckerServiceProtocol {
    
    func checkCredentials(email: String, password: String, completion: @escaping ((Result<(String?, String?), LoginInspectorErrors>) -> Void))
    func signUp(email: String, password: String, completion: @escaping ((Result<AuthDataResult, LoginInspectorErrors>) -> Void))
}

enum CheckerServiceError: Error {
    case credentialsCheckFailed
}

class CheckerService: CheckerServiceProtocol {
    
    func checkCredentials(email: String, password: String, completion: @escaping ((Result<(String?, String?), LoginInspectorErrors>) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if let error {
                completion(.failure(.credentialsCheckFailure))
                return
            }
            
            guard let result = authResult else {
                completion(.failure(LoginInspectorErrors.authResultIsNil))
                return
            }
            
            completion(.success((result.user.email, result.user.displayName)))
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping ((Result<AuthDataResult, LoginInspectorErrors>) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error {
                completion(.failure(.failedToSignUp))

                return
            }
            
            guard let result = authResult else {
                completion(.failure(LoginInspectorErrors.authResultIsNil))
                return
            }
            
            completion(.success(result))
        }
        
    }
    
}
