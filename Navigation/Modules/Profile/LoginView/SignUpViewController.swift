//
//  SignUpControllerViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 07.06.2023.
//

import UIKit

protocol SignUpDelegate: AnyObject, UITextFieldDelegate {
    func trySignUp(email: String, password: String, fullName: String)
}

class SignUpViewController: UIViewController {
    
    // MARK: - Public properties
    
    weak var delegate: SignUpDelegate?
    
    // MARK: Subviews
    
    private lazy var signUpLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold, width: .condensed)
        label.textColor = UIColor(named: "ColorSet")
        label.textAlignment = .center
        label.text = NSLocalizedString("signUp", comment: "")
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var fullnameField: UITextField = {
        let textField = CustomTextField()
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.placeholder = NSLocalizedString("fillFullName", comment: "")
        textField.autocapitalizationType = .words
        textField.returnKeyType = .done
        textField.delegate = delegate
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginField: UITextField = {
        let textField = CustomTextField()
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.placeholder = NSLocalizedString("fillEmail", comment: "")
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = delegate
        
        return textField
    }()
    
    private lazy var passwordField: UITextField = {
        let textField = CustomTextField()
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.placeholder = NSLocalizedString("fillPassword", comment: "")
        textField.autocapitalizationType = .none
        textField.textContentType = .oneTimeCode
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.delegate = delegate
    
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var showHideTextButton: UIButton = {
        let action = UIAction { [weak self] action in
            guard let self = self else { return }
            
            self.passwordField.isSecureTextEntry.toggle()
            
            switch self.passwordField.isSecureTextEntry {
            case true:
                self.showHideTextButton.setImage(UIImage(systemName: "eye"), for:.normal)
            case false:
                self.showHideTextButton.setImage(UIImage(systemName: "eye.slash"), for:.normal)
            }
        }
        
        let button = UIButton(primaryAction: action)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loginView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = Palette.dynamicTextfield
        
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.3
        view.layer.cornerRadius = 10
        view.tintColor = UIColor(named: "ColorSet")
        
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 0.0
        
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.heightAnchor.constraint(equalToConstant: 0.3).isActive = true
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addArrangedSubview(fullnameField)
        view.addArrangedSubview(separator)
        view.addArrangedSubview(loginField)
        view.addArrangedSubview(separator)
        view.addArrangedSubview(passwordField)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var confirmButton: CustomButton = {
       
        let buttonAction = { [weak self] in
            guard let self = self else { return }
            
            self.signUp()
        }
        
        let confirm = NSLocalizedString("confirm", comment: "")
        let button = CustomButton(title: "Confirm", color: UIColor(named: "ColorSet"), action: buttonAction)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    //MARK: - Private methods
    
    private func setup() {
        view.backgroundColor = Palette.dynamicBackground
        view.backgroundColor = Palette.dynamicBackground
        
        view.addSubview(signUpLabel)
        view.addSubview(loginView)
        view.addSubview(confirmButton)
        view.addSubview(showHideTextButton)
        
        let safeArea = view.safeAreaLayoutGuide
        
        let loginViewHeight = CGFloat(integerLiteral: (loginView.arrangedSubviews.count - 1) * 50)
        
        NSLayoutConstraint.activate([
            
            signUpLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100),
            signUpLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            signUpLabel.heightAnchor.constraint(equalToConstant: 50),
            
            loginView.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 50),
            loginView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            loginView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            loginView.heightAnchor.constraint(equalToConstant: loginViewHeight),
            
            showHideTextButton.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor),
            showHideTextButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: -8),
            showHideTextButton.heightAnchor.constraint(equalTo: passwordField.heightAnchor, constant: -4),
            
            confirmButton.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 16),
            confirmButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    private func signUp() {
        
        fullnameField.endEditing(true)
        loginField.endEditing(true)
        passwordField.endEditing(true)
        
        guard let login = loginField.text, !login.isEmpty else {
            
            self.presentAlert(message: NSLocalizedString("pleaseFillEmail", comment: ""))
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            self.presentAlert(message: NSLocalizedString("pleaseFillPassword", comment: ""))
            return
        }
        
        guard let fullname = fullnameField.text, !fullname.isEmpty else {
            self.presentAlert(message: NSLocalizedString("pleaseFillName", comment: ""))
            return
        }
        
        delegate?.trySignUp(email: login, password: password, fullName: fullname)

        
    }
}


