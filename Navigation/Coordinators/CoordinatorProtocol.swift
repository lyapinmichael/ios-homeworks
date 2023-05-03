//
//  CoordinatorProtocol.swift
//  Navigation
//
//  Created by Ляпин Михаил on 29.04.2023.
//


import Foundation
import UIKit.UIViewController

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    
    func start() -> UIViewController
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {}
    func removeChildCoordinator(_ coordinator: Coordinator) {}
}

protocol ModuleCoordinator: Coordinator {
    var module: Module? { get }
    var moduleType: Module.ModuleType { get }
}
