//
//  FeedModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 24.04.2023.
//

import Foundation

enum FeedModelNotification {
    static let checkResult = NSNotification.Name("checkResult")
}

class FeedModel {
    var secretWord = "discombobulate"
    
    func check(_ word: String) {
        
        let result: [String: Bool] = ["isChecked": word == secretWord]
        NotificationCenter.default.post(name: FeedModelNotification.checkResult,
                                        object: nil,
                                        userInfo: result)
    }
}
