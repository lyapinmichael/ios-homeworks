//
//  ViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 15.11.2023.
//

import UIKit

class EnterDisplayNameViewController: UIViewController {
    
    weak var delegate: SignUpDelegate?
    
    // MARK: Private properties
    
    private let login: String
    private let password: String
    
    private var displayName: String = ""
    
    // MARK: Subviews
    
    private lazy var almostThereLabel: UILabel = {
        let label = UILabel()
        label.text = "almostThere".localized.uppercased() + "!"
        label.font = .systemFont(ofSize: 18, weight: .medium, width: .standard)
        label.textColor = Palette.accentOrange
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var yourDisplayNameWillBeSeenLabel: UILabel = {
        let label = UILabel()
        
        label.text = "yourDisplayNameWillBeSeen".localized
        label.textColor = UIColor.systemGray
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var displayNameField: CustomTextField = {
        let textField = CustomTextField()
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.placeholder = NSLocalizedString("fillFullName", comment: "")
        textField.autocapitalizationType = .words
        textField.returnKeyType = .done
        textField.customDelegate = self
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var signUpButton: CustomButton = {
        
        let buttonAction = { [weak self] in
            guard let self else { return }
            self.signUp()
        }
        
        let button = CustomButton(title: "signUp".localized.uppercased(),
                                  backgroundColor: Palette.accentOrange,
                                  action: buttonAction)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var logoChechmarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LogoCheckmark")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Init
    
    init(login: String, password: String, delegate: SignUpDelegate?) {
        self.login = login
        self.password = password
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Palette.dynamicBackground
        setupSubviews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Private methods
    
    private func setupSubviews() {
        view.addSubview(almostThereLabel)
        view.addSubview(yourDisplayNameWillBeSeenLabel)
        view.addSubview(displayNameField)
        view.addSubview(signUpButton)
        view.addSubview(logoChechmarkImage)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            almostThereLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100),
            almostThereLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            almostThereLabel.heightAnchor.constraint(equalToConstant: 50),
            
            yourDisplayNameWillBeSeenLabel.topAnchor.constraint(equalTo: almostThereLabel.bottomAnchor, constant: 50),
            yourDisplayNameWillBeSeenLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            yourDisplayNameWillBeSeenLabel.widthAnchor.constraint(lessThanOrEqualTo: safeArea.widthAnchor),
            
            displayNameField.topAnchor.constraint(equalTo: yourDisplayNameWillBeSeenLabel.bottomAnchor, constant: 25),
            displayNameField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            displayNameField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            displayNameField.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: displayNameField.bottomAnchor, constant: 16),
            signUpButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            logoChechmarkImage.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 25),
            logoChechmarkImage.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            logoChechmarkImage.heightAnchor.constraint(equalToConstant: 100),
            logoChechmarkImage.widthAnchor.constraint(equalToConstant: 86)
            
        ])
        
    }
    
    private func signUp() {
        
        displayNameField.endEditing(true)
        
        delegate?.signUpViewController(trySignUp: self.login,
                                       password: self.password,
                                       fullName: self.displayName)
    }
    
    // MARK: ObjC methods
    
    @objc private func dismissKeyboard() {
        resignFirstResponder()
    }
    
    
}

// MARK: - UITextFieldDelegate

extension EnterDisplayNameViewController: CustomTextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidChangeEditing(_ textField: CustomTextField) {
        if let text = textField.text,
        !text.isEmpty,
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.displayName = text
            signUpButton.isEnabled = true
        } else {
            textField.text = nil
            signUpButton.isEnabled = false
        }
    }
    
    
}
