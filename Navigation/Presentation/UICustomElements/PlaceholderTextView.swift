//
//  PlaceholderTextView.swift
//  Navigation
//
//  Created by Ляпин Михаил on 23.01.2024.
//

import UIKit

final class PlaceholderTextView: UITextView {
    
    // MARK: Public properties
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    // MARK: Private properties
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = placeholder
        label.textColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Override properties
    
    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
    
    // MARK: Init
    
    init(placeholder: String? = nil) {
        super.init(frame: .zero, textContainer: nil)
        self.placeholder = placeholder
        setupPlaceholderLabel()
        setupText()
        NotificationCenter.default.addObserver(self, selector: #selector(inputTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setupPlaceholderLabel() {
        addSubview(placeholderLabel)
        sendSubviewToBack(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)
        ])
    }
    
    private func setupText() {
        font = UIFont.systemFont(ofSize: 19, weight: .regular)
        textColor = Palette.dynamicText
        textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    @objc private func inputTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    
}
