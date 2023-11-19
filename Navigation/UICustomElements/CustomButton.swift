//
//  CustomButton.swift
//  Navigation
//
//  Created by Ляпин Михаил on 17.02.2023.
//

import UIKit

// MARK: - CustomButton

final class CustomButton: UIButton {
    
    //  MARK: Public properties
    
    var buttonAction: (() -> Void)?
    
    // MARK: Private properties
    
    private let customAlpha: CGFloat = 0.5
    private var mainColor: UIColor?
    private var shadowColor: UIColor?
    private var titleColor: UIColor?
    
    
    private var isFeedbackEnabled = false
    private var selectionFeedbackGenerator:  UISelectionFeedbackGenerator? = nil
    
    // MARK: Override properties
    
    override var intrinsicContentSize: CGSize {
        /// This variable make it so that if in super view
        /// button's height and width constraints are not set,
        /// default constraints depending on size of text of button's
        /// label are preset.
        
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? CGSize.zero
        
        let intrinsicHeight = (labelSize.height + 20) > 44 ? (labelSize.height + 20) : 44
        let presetSize = CGSize(width: labelSize.width + 60, height: intrinsicHeight) // Add padding
        return presetSize
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.backgroundColor = self.mainColor?.withAlphaComponent(self.customAlpha).cgColor
            } else {
                layer.backgroundColor = self.mainColor?.cgColor
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = self.mainColor
            } else {
                backgroundColor = self.mainColor?.withAlphaComponent(self.customAlpha)
            }
        }
    }
    
    
    // MARK: - Init
    
    init(title: String,
         backgroundColor: UIColor? = nil,
         titleColor: UIColor? = nil,
         action: @escaping (() -> Void),
         isFeedbackEnabled: Bool = false) {
        
        super.init(frame: .zero)
        
        setup(title: title, backgourndColor: backgroundColor, titleColor: titleColor)
        
        self.isFeedbackEnabled = isFeedbackEnabled
        
        self.buttonAction = action
        
        self.addTarget(self, action: #selector(onButtonDidTap), for: .touchUpInside)
        
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
                self.setAppiarance()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            setAppiarance()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if isFeedbackEnabled {
            selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        }
        
        selectionFeedbackGenerator?.prepare()
        
        UIView.animate(withDuration: 0.07, delay: 0.02, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.layer.shadowOffset = CGSize(width: 2, height: 2)
            self.layer.backgroundColor = self.mainColor?.withAlphaComponent(self.customAlpha).cgColor
        })
        
        selectionFeedbackGenerator?.selectionChanged()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        selectionFeedbackGenerator?.prepare()
        
        UIView.animate(withDuration: 0.05, delay: 0.12, animations:  {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.layer.shadowOffset = CGSize(width: 4, height: 4)
            self.layer.backgroundColor = self.mainColor?.cgColor
        })
        
        selectionFeedbackGenerator?.selectionChanged()
        
        selectionFeedbackGenerator = nil
    }
    
    // MARK: Private methods
    
    private func setup(title: String, backgourndColor: UIColor?, titleColor: UIColor?) {
        /// Setting parameters received while initializing
        self.setTitle(title, for: .normal)
        
        if let color = backgourndColor {
            self.mainColor = color
            self.shadowColor = color.withAlphaComponent(0.7)
        } else {
            self.mainColor = UIColor.systemBlue
        }
        
        if let titleColor {
            self.titleColor = titleColor
        } else {
            self.titleColor = UIColor.white
        }
        
        setAppiarance()
        
    }
    
    private func setAppiarance() {
        /// Doing additional setup stuff for vizuals
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowColor = self.shadowColor?.cgColor
        self.layer.backgroundColor = self.mainColor?.cgColor
        self.setTitleColor(self.titleColor, for: .normal)
    }
    
    // MARK: Objc methods
    
    @objc /*private*/ func onButtonDidTap() {
        buttonAction?()
    }
    
}
