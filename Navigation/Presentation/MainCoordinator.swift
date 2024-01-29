//
//  MainCoordinator.swift
//  Navigation
//
//  Created by Ляпин Михаил on 29.04.2023.
//

import Foundation
import UIKit

final class MainCoorditanor: Coordinator {
    
    // MARK: - Public properties
    
    weak var parentCoordinator: AppCoordinator?
    
    //MARK: - Private properties
    
    private(set) var childCoordinators: [Coordinator] = []
    private let factory: AppFactory
    private let user: User
    
    //MARK: - Init
    
    init(factory: AppFactory, user: User) {
        self.factory = factory
        self.user = user
    }
    
    // MARK: - Public methods
    
    func start() -> UIViewController {
        let feedCoordinator = FeedCoordinator(moduleType: .feed, factory: factory)
        let profileCoordinator = ProfileCoordinator(moduleType: .profile(self.user), factory: factory, parentCoordinator: self)
        let favouritePostsCoordinator = FavouritePostsCoordinator(moduleType: .favouritePosts, factory: factory)
       
        let tabs = [feedCoordinator.start(),
                    profileCoordinator.start(),
                    favouritePostsCoordinator.start()]
        let mainTabBarController = MainTabBarController(viewControllers: tabs)
        
        addChildCoordinator(feedCoordinator)
        addChildCoordinator(profileCoordinator)
        addChildCoordinator(favouritePostsCoordinator)
        
        return mainTabBarController
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }
    
    func logOut() {
        parentCoordinator?.proceedToLogin(self)
    }
}
