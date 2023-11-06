//
//  User.swift
//  Navigation
//
//  Created by Ляпин Михаил on 14.04.2023.
//

import Foundation
import FirebaseFirestore
import StorageService


struct User: Codable {
    let id: String
    let login: String
    let fullName: String
    let avatarURL: String?
    var status: String?
    var posts: [DocumentReference]

    
    init(id: String, login: String, fullName: String, avatar: String? = nil, status: String? = nil) {
        self.id = id
        self.login = login
        self.fullName = fullName
        self.avatarURL = avatar
        self.status = status
        self.posts = []
    }
}

