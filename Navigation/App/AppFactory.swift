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
            let navigationController = UINavigationController(rootViewController: feedView)
            navigationController.navigationBar.tintColor = Palette.accentOrange
            
            return Module(moduleType: type, view: navigationController)
        
        case .profile(let user):
            let repository = ProfileRepository(profileData: user)
            let viewModel = ProfileViewModel(repository: repository)
            if let profileCoordinator = coordinator as? ProfileCoordinator {
                viewModel.coordinator = profileCoordinator
            }
            let profileView = ProfileViewController(with: viewModel)
            let slideOverMenu = SlideOverMenuViewController(user: user)
            slideOverMenu.delegate = profileView
            let profileRootViewController = ProfileRootViewController(profileViewController: profileView, slideOverMenuViewContoller: slideOverMenu)
    
            return Module(moduleType: type, view: profileRootViewController)
            
        case .favouritePosts:
            let favouritePostsTableController = FavouritePostsTableController()
            if let favouritePostsCorrdinator = coordinator as? FavouritePostsCoordinator {
                favouritePostsTableController.coordinator = favouritePostsCorrdinator
            }
            favouritePostsTableController.title = "savedPosts"
            let navigationController = UINavigationController(rootViewController: favouritePostsTableController)
            navigationController.navigationBar.tintColor = Palette.accentOrange
            
            return Module(moduleType: .favouritePosts, view: navigationController)
            
        case .authentication:
            let loginViewController = AuthenticationViewController()
            if let loginCoordinator = coordinator as? LoginCoordinator {
                loginViewController.coordinator = loginCoordinator
            }
        
            return Module(moduleType: .authentication, view: loginViewController)
        }
    }
}
