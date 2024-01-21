//
//  ProfileRepository.swift
//  Navigation
//
//  Created by Ляпин Михаил on 21.01.2024.
//

import Foundation

final class ProfileRepository {
    
    var profileData: Observable<User>
    var postsCount: Observable<Int>
    
    init(profileData: User) {
        self.profileData = .init(value: profileData)
        self.postsCount = .init(value: 0)
    }
    
}
