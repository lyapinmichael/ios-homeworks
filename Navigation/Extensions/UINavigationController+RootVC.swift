//
//  UINavigationController+Extension.swift
//  Navigation
//
//  Created by Ляпин Михаил on 30.04.2023.
//

import Foundation
import UIKit

extension UINavigationController {
    
    var rootViewController: UIViewController? {
        return viewControllers.first
    }
}
