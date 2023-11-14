//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Ляпин Михаил on 29.04.2023.
//

import Foundation
import UIKit
import StorageService

final class FeedCoordinator: ModuleCoordinator {
   
    weak var parentCoordinator: Coordinator?
    
    var module: Module?
    var moduleType: Module.ModuleType
    var childCoordinators: [Coordinator] = []
    
    private let factory: AppFactory
    
    enum Presentation {
        case post
        case info
    }
    
    init(moduleType: Module.ModuleType, factory: AppFactory) {
        self.moduleType = moduleType
        self.factory = factory
    }
    
    func start() -> UIViewController {
        let module = factory.makeModule(moduleType, coordinator: self)
        let viewController = module.view
        viewController.tabBarItem = moduleType.tabBarItem
        
        let navigationController = (module.view as? UINavigationController)
        configureNavBarAppearance(for: navigationController)
        
        self.module = module
       
        return viewController
    }
    
    private func configureNavBarAppearance(for navigationController: UINavigationController?) {
        
        guard let nc = navigationController else { return }
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .white
        
        nc.navigationBar.standardAppearance = navBarAppearance
        nc.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
}
