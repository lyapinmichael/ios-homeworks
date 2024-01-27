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
    var fullName: String
    var hasAvatar: Bool
}

