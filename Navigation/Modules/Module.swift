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
        case profile
        case media
        
    }
    
    let moduleType: ModuleType
    let viewModel: ViewModelProtocol?
    let view: UIViewController
}

extension Module.ModuleType {
    var tabBarItem: UITabBarItem? {
        switch self {
        case .feed:
            return UITabBarItem(title: "Feed", image: UIImage(systemName: "house.circle"), tag: 0) 
        case .profile:
            return UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        case .media:
            return UITabBarItem(title: "Media", image: UIImage(systemName: "play.circle"), tag: 2)
        }
    }
}
