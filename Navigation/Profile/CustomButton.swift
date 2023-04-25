//
//  CustomButton.swift
//  Navigation
//
//  Created by Ляпин Михаил on 17.02.2023.
//

import UIKit

final class CustomButton: UIButton {
    
    var buttonAction: (() -> Void)?
    
    private let customAlpha: CGFloat = 0.8
    private var color: UIColor?
    
    
    
    // MARK: - Init
    
    init(title: String, color: UIColor? = nil, action: @escaping (() -> Void)) {
        super.init(frame: .zero)
        
        setup(title: title, color: color)
        
        self.buttonAction = action
        
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    
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

    // MARK: - Private methods
    
    private func setup(title: String, color: UIColor?) {
       /// Setting parameters received while initializing
        self.setTitle(title, for: .normal)
        
        if let color = color {
            self.color = color
        } else {
            self.color = UIColor.systemBlue
        }
        /// Doing additional setup stuff for vizuals
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.backgroundColor = .white
        self.layer.backgroundColor = self.color?.cgColor
        

    }

    // MARK: - Animations of press
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
    
    // MARK: - Objc methods
    
    @objc func buttonTapped() {
        buttonAction?()
    }
    
}
