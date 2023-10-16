//
//  LoginFactory.swift
//  Navigation
//
//  Created by Ляпин Михаил on 16.04.2023.
//

import Foundation

protocol LoginFactory {
    static func makeLoginInspector() -> AuthenticationService
}

struct MyLoginFactory: LoginFactory {
   
    static func makeLoginInspector() -> AuthenticationService {
        return AuthenticationService()
    }
    
    
}
