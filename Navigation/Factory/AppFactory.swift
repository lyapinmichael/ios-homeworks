//
//  AppFactory.swift
//  Navigation
//
//  Created by Ляпин Михаил on 29.04.2023.
//

import Foundation
import UIKit

final class AppFactory {
    
    func makeModule(_ type: Module.ModuleType) -> Module {
        switch type {
        case .feed:
            let view = UINavigationController(rootViewController: FeedViewController())
            view.title = NSLocalizedString("profile", comment: "")
            return Module(moduleType: type, view: view)
        
        case .profile:
            
            let loginView = LogInViewController()
        
            let view = UINavigationController(rootViewController: loginView)
            
            return Module(moduleType: type, view: view)
            
        case .media:
            
            let mediaViewContoller = MediaViewController()
            let view = UINavigationController(rootViewController: mediaViewContoller)
            ///
            /// TODO: if View Model will be needed for Media module, make sure that it is **Coordinator** that instantiates View Model and passes it to View
            /// 
            return Module(moduleType: type, view: view)
            
        case .favouritePosts:
            
            let favouritePostsTableController = FavouritePostsTableController()
            let view = UINavigationController(rootViewController: favouritePostsTableController)
            view.title = NSLocalizedString("favoritePosts", comment: "")
            
            return Module(moduleType: .favouritePosts, view: view)
            
        case .locationController:
            
            let locationController = LocationViewController()
            let view = UINavigationController(rootViewController: locationController)
            
            return Module(moduleType: .locationController, view: view)
            
        }
    }
    
}
