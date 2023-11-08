//
//  LoginCoordinator.swift
//  Navigation
//
//  Created by Ляпин Михаил on 06.11.2023.
//

import UIKit

final class LoginCoordinator: ModuleCoordinator {
    
    var module: Module?
    
    var moduleType: Module.ModuleType = .login
    
    var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: Coordinator?

    private let factory: AppFactory
    
    init(factory: AppFactory) {
        self.factory = factory
    }
    
    func start() -> UIViewController {
        self.module = factory.makeModule(moduleType, coordinator: self)
        let loginViewController = module?.view ?? UIViewController()
        return loginViewController
    }
    
    func proceedToMain(_ user: User) {
        (parentCoordinator as? AppCoordinator)?.proceedToMain(user)
    }
}
