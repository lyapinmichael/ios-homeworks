//
//  FavouritePostsCoordinator.swift
//  Navigation
//
//  Created by Ляпин Михаил on 23.06.2023.
//

import Foundation
import UIKit

final class FavouritePostsCoordinator: ModuleCoordinator {
    
    var parentCoordinator: Coordinator?
    
    var module: Module?
    var moduleType: Module.ModuleType
    var childCoordinators: [Coordinator] = []
    
    private let factory: AppFactory
    
    init(moduleType: Module.ModuleType, factory: AppFactory) {
        self.moduleType = moduleType
        self.factory = factory
    }
    
    func start() -> UIViewController {
        let module = factory.makeModule(moduleType, coordinator: self)
        let viewController = module.view
        viewController.tabBarItem = moduleType.tabBarItem
        
        let rootViewController = (module.view as? UINavigationController)?.rootViewController
        (rootViewController as? FavouritePostsTableController)?.coordinator = self
        
        return viewController
    }
    
    
}
