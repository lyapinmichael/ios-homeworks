//
//  User.swift
//  Navigation
//
//  Created by Ляпин Михаил on 14.04.2023.
//

import Foundation
import UIKit



class User {
    let login: String
    let fullName: String
    let avatar: UIImage?
    var status: String?
    
    init(login: String, fullName: String, avatar: UIImage? = nil, status: String? = nil) {
        self.login = login
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}

