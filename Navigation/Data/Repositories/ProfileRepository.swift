//
//  ProfileRepository.swift
//  Navigation
//
//  Created by Ляпин Михаил on 21.01.2024.
//

import Foundation
import StorageService

final class ProfileRepository {
    
    var profileData: Observable<User>
    var postsCount: Observable<Int>
    var postData: Observable<[Post]>
    
    init(profileData: User) {
        self.profileData = .init(value: profileData)
        self.postsCount = .init(value: 0)
        self.postData = .init(value: [])
    }
    
}
