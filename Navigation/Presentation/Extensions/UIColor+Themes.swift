//
//  UIColor+Themes.swift
//  Navigation
//
//  Created by Ляпин Михаил on 17.09.2023.
//

import Foundation
import UIKit

extension UIColor {
    
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }
        
        return UIColor(dynamicProvider: { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        })
    }
    
}
