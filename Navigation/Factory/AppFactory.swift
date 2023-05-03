//
//  AppFactory.swift
//  Navigation
//
//  Created by Ляпин Михаил on 29.04.2023.
//

import Foundation
import UIKit

final class AppFactory {
    
    let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func makeModule(_ type: Module.ModuleType) -> Module {
        switch type {
        case .feed:
            let view = UINavigationController(rootViewController: FeedViewController())
            view.title = "Profile"
            return Module(moduleType: type, viewModel: nil, view: view)
        
        case .profile:
            
            let loginView = LogInViewController()
            loginView.loginDelegate = MyLoginFactory.makeLoginInspector()
            
            let view = UINavigationController(rootViewController: loginView)
            
            return Module(moduleType: type, viewModel: nil, view: view)
            
        }
    }
    
}
