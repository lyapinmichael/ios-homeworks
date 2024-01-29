//
//  UIButton+pont.swift
//  Navigation
//
//  Created by Ляпин Михаил on 25.01.2024.
//

import UIKit

final class WideTapAreaButton: UIButton {
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            return bounds.insetBy(dx: -20, dy: -20).contains(point)
        }

}
