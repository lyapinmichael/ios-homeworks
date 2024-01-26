//
//  NSLyaoutConstraint+withMultiplier.swift
//  Navigation
//
//  Created by Ляпин Михаил on 26.01.2024.
//

import UIKit

extension NSLayoutConstraint {
    
    func withMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
    
}
