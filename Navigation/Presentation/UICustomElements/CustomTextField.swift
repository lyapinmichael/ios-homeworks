//
//  TextFieldExtension.swift
//  Navigation
//
//  Created by Ляпин Михаил on 22.02.2023.
//

import UIKit

protocol CustomTextFieldDelegate: UITextFieldDelegate {
    
    func textFieldDidChangeEditing(_ textField: CustomTextField)
    
}

extension CustomTextFieldDelegate {
    
    func textFieldDidChangeEditing(_ textField: CustomTextField) {}
    
}

// MARK: - CustomTextField

final class CustomTextField: UITextField {

    // MARK: Public properties

    weak var customDelegate: CustomTextFieldDelegate?
    
    var padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(autocapitalizationType: UITextAutocapitalizationType = .none,
                     returnKeyType: UIReturnKeyType = .default,
                     textAlignment: NSTextAlignment = .left) {
        self.init(frame: .zero)
        
        self.autocapitalizationType = autocapitalizationType
        self.returnKeyType = returnKeyType
        self.textAlignment = textAlignment
        
        addTarget(self, action: #selector(textFieldDidChangeEditing), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
           let rect = super.editingRect(forBounds: bounds)
           return rect.inset(by: padding)
    }
    
    // MARK: Public methods
    
    func addShowHideTextButton(tintColor: UIColor? = nil) {
        /// This method is used to create muiltiple identical UIButtons without
        ///  redeclaring them in a corresponding property.
        ///  It is returning a view as it is expected for button to be padded
        ///  from the edge of text field, if it is added to a text field as a
        ///  right view
        
        self.isSecureTextEntry = true
        
        let button = UIButton(type: .system)
        
        let setButtonImage = {
            let image = self.isSecureTextEntry ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
            button.setImage(image, for: .normal)
        }
        
        let action = UIAction { _ in
            
            self.isSecureTextEntry.toggle()
            setButtonImage()
        }
        
        setButtonImage()
        button.addAction(action, for: .touchUpInside)
        button.tintColor = tintColor
        
        let buttonSize = button.intrinsicContentSize
        
        let containerView = UIView(frame: CGRect(x: .zero,
                                                 y: .zero,
                                                 width: buttonSize.width + 16,
                                                 height: buttonSize.height))
        
        button.frame = CGRect(x: .zero,
                              y: .zero,
                              width: buttonSize.width,
                              height: buttonSize.height)
        
        containerView.addSubview(button)
        
        self.rightViewMode = .always
        self.rightView = containerView
    }
    
    // MARK: Private methods
    
    private func setup() {
        
        font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray.cgColor
        
    }
    
    @objc private func textFieldDidChangeEditing() {
        customDelegate?.textFieldDidChangeEditing(self)
    }
    
    
}
