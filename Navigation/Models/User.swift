//
//  User.swift
//  Navigation
//
//  Created by Ляпин Михаил on 14.04.2023.
//

import Foundation
import UIKit
import StorageService


struct User: Codable {
    let login: String
    let fullName: String
//    let avatar: UIImage?
    var status: String?
    var posts: [Post]
    
    init(login: String, fullName: String, status: String? = nil, posts: [Post] = []) {
        self.login = login
        self.fullName = fullName
//        self.avatar = avatar
        self.status = status
        self.posts = posts
    }
}

