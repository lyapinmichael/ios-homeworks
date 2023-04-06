//
//  Photos.swift
//  Navigation
//
//  Created by Ляпин Михаил on 04.03.2023.
//

import Foundation

struct Photo {
    let name: String
}

extension Photo {
    static func make() -> [Photo]{
        [
            Photo(name: "Vader1"),
            Photo(name: "Vader2"),
            Photo(name: "Vader3"),
            Photo(name: "Vader4"),
            Photo(name: "TieBomber"),
            Photo(name: "AT-AT"),
            Photo(name: "Vader5"),
            Photo(name: "CoruscantSenateDistrict"),
            Photo(name: "Geonosis"),
            Photo(name: "Tidirium"),
            Photo(name: "StarDestroyer"),
            Photo(name: "Operation"),
            Photo(name: "OnCorvette"),
            Photo(name: "TrenchPursuit"),
            Photo(name: "Vader6"),
            Photo(name: "Vader7"),
            Photo(name: "Vader8"),
            Photo(name: "AnakinWithMother"),
            Photo(name: "AnakinWithPadme"),
            Photo(name: "Vader9")
            
        ]
    }
}
