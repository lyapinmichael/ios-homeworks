//
//  Photos.swift
//  Navigation
//
//  Created by Ляпин Михаил on 04.03.2023.
//

import Foundation
import UIKit

class Photo {
    static var shared = Photo()
    
    var testPhotos: [UIImage] = [
            UIImage.named("Vader1"),
            UIImage.named("Vader2"),
            UIImage.named("Vader3"),
            UIImage.named("Vader4"),
            UIImage.named("TieBomber"),
            UIImage.named("AT-AT"),
            UIImage.named("Vader5"),
            UIImage.named("CoruscantSenateDistrict"),
            UIImage.named("Geonosis"),
            UIImage.named("Tidirium"),
            UIImage.named("StarDestroyer"),
            UIImage.named("Operation"),
            UIImage.named("OnCorvette"),
            UIImage.named("TrenchPursuit"),
            UIImage.named("Vader6"),
            UIImage.named("Vader7"),
            UIImage.named("Vader8"),
            UIImage.named("AnakinWithMother"),
            UIImage.named("AnakinWithPadme"),
            UIImage.named("Vader9")
        
        ]
    
    private init() {}
}

extension Photo {
 
}
