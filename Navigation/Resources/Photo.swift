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
            Photo(name: "Vader4")
        ]
    }
}
