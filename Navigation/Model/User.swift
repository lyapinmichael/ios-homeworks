//
//  User.swift
//  Navigation
//
//  Created by Ляпин Михаил on 14.04.2023.
//

import Foundation
import UIKit

protocol UserService {
    var user: User { get set }
    
    func authorize(login: String) -> User?
}

extension UserService {
    func authorize(login: String) -> User? {
        return login == user.login ? user : nil
    }
}

class User {
    let login: String
    let fullName: String
    let avatar: UIImage?
    let status: String?
    
    init(login: String, fullName: String, avatar: UIImage? = nil, status: String? = nil) {
        self.login = login
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}

class CurrentUserService: UserService {
    
    var user: User = User(login: "furiousVader66",
                          fullName: "DarthVader",
                          avatar: UIImage(named: "DarthVader"),
                          status: "Join the Dark side!..")
}

class TestUserService: UserService {
    
    var user = User(login: "test",
                        fullName: "TestUser")

}
