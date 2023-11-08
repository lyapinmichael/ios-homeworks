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
   
    var parentCoordinator: Coordinator?
    
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
    
    func present(_ presentation: Presentation) {
        
        switch presentation {
        case .post:
            let post = Post.make()[0]
            let postViewController = PostViewController()
            postViewController.coordinator = self
            postViewController.title = post.title
            (module?.view as? UINavigationController)?.pushViewController(postViewController, animated: true)
        case .info:
            let infoViewController = InfoViewController()
            infoViewController.modalPresentationStyle = .pageSheet
            module?.view.present(infoViewController, animated: true)
        }
        
        
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
