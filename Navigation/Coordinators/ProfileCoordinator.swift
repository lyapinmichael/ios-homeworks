//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Ляпин Михаил on 29.04.2023.
//

import Foundation
import UIKit

final class ProfileCoordinator: ModuleCoordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var module: Module?
    private(set) var moduleType: Module.ModuleType
    private(set) var childCoordinators: [Coordinator] = []
    
    private let factory: AppFactory
    
    init(moduleType: Module.ModuleType, factory: AppFactory, parentCoordinator: Coordinator) {
        self.moduleType = moduleType
        self.factory = factory
        self.parentCoordinator = parentCoordinator
    }
    
    func start() -> UIViewController {
        let module = factory.makeModule(moduleType, coordinator: self)
        let viewController = module.view
        let rootViewController = (viewController as? UINavigationController)?.rootViewController
       
        viewController.tabBarItem = moduleType.tabBarItem
        self.module = module
        return viewController
    }
    
    func logOut() {
//        let navigationController = (module?.view as? UINavigationController)
//        guard var viewControllers = navigationController?.viewControllers else { return }
//        
//        _ = viewControllers.popLast()
//        let loginViewController = LogInViewController()
////        loginViewController.coordinator = self
//        viewControllers.append(loginViewController)
//        navigationController?.setViewControllers(viewControllers, animated: true)
        
        (parentCoordinator as? MainCoorditanor)?.logOut()
    }
}
