//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Ляпин Михаил on 29.04.2023.
//

import Foundation
import UIKit

final class FeedCoordinator: ModuleCoordinator {
    var module: Module?
    var moduleType: Module.ModuleType
    var childCoordinators: [Coordinator] = []
    
    private let factory: AppFactory
    
    init(moduleType: Module.ModuleType, factory: AppFactory) {
        self.moduleType = moduleType
        self.factory = factory
    }
    
    func start() -> UIViewController {
        let module = factory.makeModule(moduleType)
        let viewController = module.view
        viewController.tabBarItem = moduleType.tabBarItem
        
        let navigationController = (module.view as? UINavigationController)
        configureNavBarAppearance(for: navigationController)
        
        self.module = module
       
        return viewController
    }
    
    func pushToPostView() {
        let postViewController = PostViewController()
        (module?.view as? UINavigationController)?.pushViewController(postViewController, animated: true)
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
