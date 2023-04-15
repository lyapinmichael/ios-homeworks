//
//  LoginFactory.swift
//  Navigation
//
//  Created by Ляпин Михаил on 16.04.2023.
//

import Foundation

protocol LoginFactory {
    static func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
   
    static func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
    
    
}
