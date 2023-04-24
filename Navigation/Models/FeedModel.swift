//
//  FeedModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 24.04.2023.
//

import Foundation

class FeedModel {
    var secretWord = "discombobulate"
    
    func check(_ word: String) -> Bool {
        word == secretWord
    }
}
