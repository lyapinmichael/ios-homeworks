//
//  MainCoordinator.swift
//  Navigation
//
//  Created by Ляпин Михаил on 29.04.2023.
//

import Foundation
import UIKit

final class MainCoorditanor: Coordinator {
    
    //MARK: - Private properties
    
    private(set) var childCoordinators: [Coordinator] = []
    private let factory: AppFactory
    
    //MARK: - Init
    
    init(factory: AppFactory) {
        self.factory = factory
    }
    
    // MARK: - Public methods
    
    func start() -> UIViewController {
        let feedCoordinator = FeedCoordinator(moduleType: .feed, factory: factory)
        let profileCoordinator = ProfileCoordinator(moduleType: .profile, factory: factory)
       
        let mainTabBarController = MainTabBarController(viewControllers: [
            feedCoordinator.start(),
            profileCoordinator.start()
        ])
        
        addChildCoordinator(feedCoordinator)
        addChildCoordinator(profileCoordinator)
        
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
    
    
}
