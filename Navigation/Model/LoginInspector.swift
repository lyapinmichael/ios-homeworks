//
//  LoginInspector.swift
//  Navigation
//
//  Created by Ляпин Михаил on 15.04.2023.
//

import Foundation

enum LoginInspectorErrors: Error {
    case loginNotRegistered
    case wrongLoginOrPassword
    case emptyLogin
    case emptyPassword
    
}

struct LoginInspector: LogInViewControllerDelegate {
    func check(login: String, password: String) -> Bool {
        return Checker.shared.check(login: login, password: password)
    }
}
