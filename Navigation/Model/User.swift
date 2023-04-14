//
//  User.swift
//  Navigation
//
//  Created by Ляпин Михаил on 14.04.2023.
//

import Foundation
import UIKit

protocol UserService {
    func authorize(login: String) -> User?
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
    
    let user: User
    
    init(for user: User) {
        self.user = user
    }
    
    func authorize(login: String) -> User? {
        guard login == user.login else {
            return nil
        }
        return user
    }
}
