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
