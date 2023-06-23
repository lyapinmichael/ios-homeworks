//
//  CheckerService.swift
//  Navigation
//
//  Created by Ляпин Михаил on 06.06.2023.
//

import Foundation
import FirebaseAuth


protocol CheckerServiceProtocol {
    
    func checkCredentials(email: String, password: String, completion: @escaping ((Result<AuthDataResult, Error>) -> Void))
    func signUp(email: String, password: String, completion: @escaping ((Result<AuthDataResult, Error>) -> Void))
}

class CheckerService: CheckerServiceProtocol {
    
    func checkCredentials(email: String, password: String, completion: @escaping ((Result<AuthDataResult, Error>) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let result = authResult else {
                completion(.failure(LoginInspectorErrors.authResultIsNil))
                return
            }
            
            completion(.success(result))
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping ((Result<AuthDataResult, Error>) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error {
                completion(.failure(error))

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
