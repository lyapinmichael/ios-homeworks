//
//  UIImageExtension.swift
//  Navigation
//
//  Created by Ляпин Михаил on 19.04.2023.
//

import Foundation
import UIKit

extension UIImage {
  static func named(_ name: String) -> UIImage {
    if let image = UIImage(named: name) {
      return image
    } else {
      fatalError("Could not initialize \(UIImage.self) named \(name).")
    }
  }
}
