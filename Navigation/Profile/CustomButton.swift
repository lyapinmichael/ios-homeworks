//
//  CustomButton.swift
//  Navigation
//
//  Created by Ляпин Михаил on 17.02.2023.
//

import UIKit

final class CustomButton: UIButton {
    private var color: UIColor = .systemBlue
    private let touchDownAlpha: CGFloat = 0.3
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                touchDown()
            } else {
                cancelTracking(with: nil)
                touchUp()
            }
        }
    }
    
    func setup() {
        backgroundColor = .white
        clipsToBounds = true
        titleLabel?.textColor = .white
        layer.backgroundColor = color.cgColor
        layer.cornerRadius = 4
        
        layer.masksToBounds = false
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 4
        layer.shadowColor = UIColor.black.cgColor
    }
    
    func touchDown() {
        UIView.animate(withDuration: 0.09, delay: 0, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.layer.shadowOffset = CGSize(width: 2, height: 2)
            self.layer.backgroundColor = self.color.withAlphaComponent(self.touchDownAlpha).cgColor
        })
    }

    func touchUp() {
        UIView.animate(withDuration: 0.05, delay: 0, animations:  {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.layer.shadowOffset = CGSize(width: 4, height: 4)
            self.layer.backgroundColor = self.color.cgColor
        })
    }
    
    convenience init(color: UIColor? = nil, title: String? = nil) {
        self.init(type: .custom)
        
        if let color = color {
            self.color = color
        }
        
        if let title = title {
            setTitle(title, for: .normal)
        } else {
            setTitle("Button", for: .normal)
        }
        
        setup()
        
    }
    
}
