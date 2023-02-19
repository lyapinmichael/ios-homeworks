//
//  StatusTextField.swift
//  Navigation
//
//  Created by Ляпин Михаил on 18.02.2023.
//

import UIKit

final class StatusTextField: UITextField, UITextFieldDelegate {
    
    private let padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    private func setupTextField() {
        delegate = self
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 12
        layer.backgroundColor = UIColor.white.cgColor
        
        placeholder = "What's new?" //Я НЕ ПОНИМАЮ ПОЧЕМУ ОН НЕ ОТОБРАЖАЕТСЯ. ХЭЛП
        
        font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textColor = UIColor.black
        returnKeyType = .done
        enablesReturnKeyAutomatically = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
    override func layoutSubviews() {
        setupTextField()
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    
}
