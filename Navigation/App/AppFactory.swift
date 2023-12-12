//
//  AppFactory.swift
//  Navigation
//
//  Created by Ляпин Михаил on 29.04.2023.
//

import Foundation
import UIKit

final class AppFactory {
    
    func makeModule(_ type: Module.ModuleType, coordinator: ModuleCoordinator) -> Module {
        switch type {
        case .feed:
            let feedView = FeedViewController()
            feedView.title = NSLocalizedString("profile", comment: "")
            
            if let feedCoordinator = coordinator as? FeedCoordinator {
                feedView.coordinator = feedCoordinator
            }
            
            return Module(moduleType: type, view: UINavigationController(rootViewController: feedView))
        
        case .profile(let user):
            
            let viewModel = ProfileViewModel(withUser: user)
            
            if let profileCoordinator = coordinator as? ProfileCoordinator {
                viewModel.coordinator = profileCoordinator
            }
            
            let profileView = ProfileViewController(with: viewModel)
            let profileNavigationController = UINavigationController(rootViewController: profileView)
        
            let slideOverMenu = SlideOverMenuViewController(user: user)
            slideOverMenu.delegate = profileView
            
            let  profileRootViewController = ProfileRootViewController(profileViewController: profileView, slideOverMenuViewContoller: slideOverMenu)
    
            return Module(moduleType: type, view: profileRootViewController)
            
        case .favouritePosts:
            
            let favouritePostsTableController = FavouritePostsTableController()
            
            if let favouritePostsCorrdinator = coordinator as? FavouritePostsCoordinator {
                favouritePostsTableController.coordinator = favouritePostsCorrdinator
            }
            
            favouritePostsTableController.title = NSLocalizedString("favoritePosts", comment: "")
            
            return Module(moduleType: .favouritePosts, view: UINavigationController(rootViewController: favouritePostsTableController))
            
        case .authentication:
            let loginViewController = AuthenticationViewController()
            
            if let loginCoordinator = coordinator as? LoginCoordinator {
                loginViewController.coordinator = loginCoordinator
            }
        
            return Module(moduleType: .authentication, view: loginViewController)
        }
    }
}
