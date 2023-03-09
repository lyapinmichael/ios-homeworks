//
//  CustomButton.swift
//  Navigation
//
//  Created by Ляпин Михаил on 17.02.2023.
//

import UIKit

final class CustomButton: UIButton {

    private let customAlpha: CGFloat = 0.8
    var color: UIColor?
    
    enum ButtonActions: String {
        case printStatus = "Print status"
        case setStatus = "Set status"
        case logIn = "Log In"
    }
    
    var buttonAction: ButtonActions? {
        willSet {
            let title = newValue?.rawValue
            switch newValue{
            case .printStatus, .setStatus, .logIn:
                setTitle(title, for: .normal)
            case .none:
                setTitle("Button", for: .normal)
            }
        }
    }
    
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
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.backgroundColor = self.color?.withAlphaComponent(self.customAlpha).cgColor
            } else {
                layer.backgroundColor = self.color?.cgColor
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                layer.backgroundColor = self.color?.cgColor
            } else {
                layer.backgroundColor = self.color?.withAlphaComponent(self.customAlpha).cgColor
            }
        }
    }

    
    func touchDown() {
        UIView.animate(withDuration: 0.07, delay: 0.02, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.layer.shadowOffset = CGSize(width: 2, height: 2)
            self.layer.backgroundColor = self.color?.withAlphaComponent(self.customAlpha).cgColor
        })
    }
    
    func touchUp() {
        UIView.animate(withDuration: 0.05, delay: 0.12, animations:  {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.layer.shadowOffset = CGSize(width: 4, height: 4)
            self.layer.backgroundColor = self.color?.cgColor
        })
    }
    
    convenience init(custom: Bool, initAction: ButtonActions = .printStatus, color: UIColor? = nil) {
        self.init(type: .custom)
        
        if let color = color {
            self.color = color
        } else {
            self.color = UIColor.systemBlue
        }
        
        buttonAction = initAction
        setTitle(initAction.rawValue, for: .normal)
        
    }
}
