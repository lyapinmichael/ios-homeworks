//
//  MediaCoordinator.swift
//  Navigation
//
//  Created by Ляпин Михаил on 27.05.2023.
//

import UIKit
import Foundation

final class MediaCoordinator: ModuleCoordinator {
    var module: Module?
    private(set) var moduleType: Module.ModuleType
    private(set) var childCoordinators: [Coordinator] = []
    
    private let factory: AppFactory
    
    init(moduleType: Module.ModuleType, factory: AppFactory) {
        self.moduleType = moduleType
        self.factory = factory
    }
    
    func start() -> UIViewController {
        let module = factory.makeModule(.media)
        let viewController = module.view
        viewController.tabBarItem = moduleType.tabBarItem
        
        
        (viewController as? MediaViewController)?.coordinator = self
        viewController.tabBarItem = moduleType.tabBarItem
        self.module = module
        return viewController
    }
    
    
}
