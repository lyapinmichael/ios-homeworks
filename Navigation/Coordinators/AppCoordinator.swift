//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Ляпин Михаил on 06.11.2023.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController = UINavigationController()
    
    private let factory: AppFactory
    
    init(factory: AppFactory) {
        self.factory = factory
        self.configureNavBarAppearance()
    }
    
    func start() -> UIViewController {
        let loginCoordinator = LoginCoordinator(factory: factory)
        loginCoordinator.parentCoordinator = self
        addChildCoordinator(loginCoordinator)
        let loginViewContoller = loginCoordinator.start()
        navigationController.viewControllers.append(loginViewContoller)
        return navigationController
    }
    
    func proceedToMain(_ user: User) {
        let mainCoordinator = MainCoorditanor(factory: factory, user: user)
        mainCoordinator.parentCoordinator = self
        addChildCoordinator(mainCoordinator)
        
        let mainViewController = mainCoordinator.start()
        navigationController.setViewControllers([mainViewController], animated: true)
        
        guard let loginCoordinator = childCoordinators.first(where: {$0 is LoginCoordinator}) else { return }
        removeChildCoordinator(loginCoordinator)
    }
    
    func proceedToLogin(_ childCoordinator: Coordinator? = nil) {
        
        if let childCoordinator {
            removeChildCoordinator(childCoordinator)
        }
        
        let loginCoordinator = LoginCoordinator(factory: factory)
        loginCoordinator.parentCoordinator = self
        addChildCoordinator(loginCoordinator)
        let loginViewContoller = loginCoordinator.start()
        navigationController.setViewControllers([loginViewContoller], animated: true)
        
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }
    
    // MARK: - Private methods
    
    private func configureNavBarAppearance() {
        
        navigationController.navigationBar.isHidden = true
        navigationController.navigationBar.backIndicatorImage = UIImage()
        navigationController.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        
    }
}
