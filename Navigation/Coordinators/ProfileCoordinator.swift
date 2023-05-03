//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Ляпин Михаил on 29.04.2023.
//

import Foundation
import UIKit

final class ProfileCoordinator: ModuleCoordinator {
    var module: Module?
    private(set) var moduleType: Module.ModuleType
    private(set) var childCoordinators: [Coordinator] = []
    
    private let factory: AppFactory
    
    init(moduleType: Module.ModuleType, factory: AppFactory) {
        self.moduleType = moduleType
        self.factory = factory
        
    }
    
    func start() -> UIViewController {
        let module = factory.makeModule(moduleType)
        let viewController = module.view
        let rootViewController = (viewController as? UINavigationController)?.rootViewController
        (rootViewController as? LogInViewController)?.coordinator = self
        viewController.tabBarItem = moduleType.tabBarItem
        self.module = module
        return viewController
    }
    
    func proceedToProfile() {
        let user = factory.userService.user
        let viewModel = ProfileViewModel(withUser: user)
        viewModel.coordinator = self
        
        let navigationController = (module?.view as? UINavigationController)
        guard var viewControllers = navigationController?.viewControllers else {
            print("some error with view controllers occured")
            return
        }
        _ = viewControllers.popLast()
        viewControllers.append(ProfileViewController(with: viewModel))
        navigationController?.setViewControllers(viewControllers, animated: true)
        
    
    }
    
    
}
