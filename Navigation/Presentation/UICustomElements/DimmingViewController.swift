//
//  DimminViewControllerProtocol.swift
//  Navigation
//
//  Created by Ляпин Михаил on 26.01.2024.
//

import UIKit

protocol DimmingViewControllerProtocol: UIViewController {
    func present(on viewController: UIViewController)
    func show(on viewController: UIViewController)
    func hide(completion: @escaping () -> Void)
}

/// 
/// `DimmingViewController` is a base implementation of `DimingViewControllerProtocol`. It is
/// meant to be used as a superclass for all custom dimming view controllers, that
/// need to be presented over another view controller as an overlay rather than modally
/// 
class DimmingViewController: UIViewController, DimmingViewControllerProtocol {
    
    
    ///
    /// A special variable returning true if `DimmingViewController` is being
    /// modally presented by any another `UIViewController`.
    ///
    private var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
    
    ///
    /// `present(on:)` is called on instance of `DimmingViewController` subclass. Takes
    /// modally presenting `UIViewController` as the only parameter.
    ///
    func present(on viewController: UIViewController) {
        viewController.presentedViewController?.dismiss(animated: true)
        self.modalPresentationStyle = .overFullScreen
        viewController.present(self, animated: true)

    }
    
    ///
    /// `show(on:)` is called on instance of `DimmingViewController` subclass. Takes
    /// showing `UIViewController` as the only parameter. Used to replecate but
    /// actually avoid modal presentation.
    ///
    func show(on viewController: UIViewController) {
        viewController.addChild(self)
        self.view.frame = viewController.view.frame
        viewController.view.addSubview(self.view)
        self.didMove(toParent: viewController)
    }
    
    /// 
    /// `hide()` is called  on instance of `DimmingViewController` to stop showing or
    /// presenting it, if it is being presented modally from another `UIViewController`.
    ///
    func hide(completion: @escaping () -> Void = {}) {
        if isModal {
            dismiss(animated: true, completion: completion)
        } else {
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
            completion()
        }
    }
}
