//
//  Module.swift
//  Navigation
//
//  Created by Ляпин Михаил on 29.04.2023.
//

import Foundation
import UIKit.UIViewController
import UIKit.UITabBarItem

protocol ViewModelProtocol: AnyObject {}

struct Module {
    enum ModuleType {
        case feed
        case profile(User)
        case favouritePosts
        case authentication
        
    }
    
    let moduleType: ModuleType
    let view: UIViewController
}

extension Module.ModuleType {
    var tabBarItem: UITabBarItem? {
        switch self {
        case .feed:
            return UITabBarItem(title: NSLocalizedString("feed", comment: ""), image: UIImage(systemName: "house.circle"), tag: 0)
        case .profile:
            return UITabBarItem(title: NSLocalizedString("profile", comment: ""), image: UIImage(systemName: "person.circle"), tag: 1)
        case .favouritePosts:
            return UITabBarItem(title: NSLocalizedString("favoritePosts", comment: ""), image: UIImage(systemName: "star.fill"), tag: 3)
        case .authentication:
            return nil
        }
    }
}
