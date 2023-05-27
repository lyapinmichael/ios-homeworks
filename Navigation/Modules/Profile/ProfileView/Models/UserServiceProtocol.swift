//
//  UserService.swift
//  Navigation
//
//  Created by Ляпин Михаил on 29.04.2023.
//

import Foundation
import UIKit.UIImage

protocol UserServiceProtocol {
    var user: User { get set }
    
    func authorize(login: String, completion: @escaping (Result<User, LoginInspectorErrors>) -> Void)
}

extension UserServiceProtocol {
    func authorize(login: String, completion: @escaping (Result<User, LoginInspectorErrors>) -> Void)  {
        if login == user.login {
            completion(.success(user))
        } else {
            let errorMessage = "User with login \(login) not registered"
            completion(.failure(.loginNotRegistered(errorMessage: errorMessage)))
        }
    }
}

class CurrentUserService: UserServiceProtocol {
    
    var user: User = User(login: "furiousVader66",
                          fullName: "DarthVader",
                          avatar: UIImage(named: "DarthVader"),
                          status: "Join the Dark side!..")
}

class TestUserService: UserServiceProtocol {
    
    var user = User(login: "test",
                        fullName: "TestUser")

}

