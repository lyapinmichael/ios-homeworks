//
//  LocationCoordinator.swift
//  Navigation
//
//  Created by Ляпин Михаил on 08.09.2023.
//

import Foundation
import UIKit

final class LocationCoordinator: Coordinator {
   
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
        let viewModel = LocationViewModel()
        viewModel.coordinator = self
        (rootViewController as? LocationViewController)?.viewModel = viewModel
        viewController.tabBarItem = moduleType.tabBarItem
        self.module = module
        return viewController
    }
    
}
