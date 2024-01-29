//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Ляпин Михаил on 29.04.2023.
//

import Foundation
import UIKit

final class ProfileCoordinator: ModuleCoordinator {
    
    var parentCoordinator: Coordinator?
    
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
       
        viewController.tabBarItem = moduleType.tabBarItem
        self.module = module
        return viewController
    }
    
    func logOut() {
        (parentCoordinator as? MainCoorditanor)?.logOut()
    }
}
