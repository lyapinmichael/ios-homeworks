//
//  Users.swift
//  Navigation
//
//  Created by Ляпин Михаил on 14.04.2023.
//

import Foundation
import UIKit

struct UsersStore {
    static var all: [User] = [ User(login: "furiousVader66",
                                    fullName: "Darth Vader",
                                    avatar: UIImage(named: "DarthVader")),
                               User(login: "mighty_master_yoda",
                                    fullName: "Master Yoda",
                                    avatar: UIImage(named: "MasterYoda"))
    ]
}
