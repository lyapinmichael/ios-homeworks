//
//  SignUpControllerViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 07.06.2023.
//

import UIKit

protocol SignUpDelegate: AnyObject, UITextFieldDelegate {
    func signUpViewController(trySignUp email: String, password: String, fullName: String)
    func signUpViewController(_ signUpViewController: SignUpViewController, checkIfExists email: String)
}

class SignUpViewController: UIViewController {
    
    // MARK: Public properties
    
    weak var delegate: SignUpDelegate?
    
    // MARK: Subviews
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium, width: .standard)
        label.textColor = Palette.dynamicText
        label.textAlignment = .center
        label.text = NSLocalizedString("signUp", comment: "").uppercased()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fillYourEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "fillEmail".localized
        label.textColor = UIColor.systemGray3
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var yourEmailWillBeUsedLabel: UILabel = {
        let label = UILabel()
        
        label.text = "yourEmailWillBeUsed".localized
        label.textColor = UIColor.systemGray
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginTextField: UITextField = {
        let textField = CustomTextField(autocapitalizationType: .none,
                                        returnKeyType: .done,
                                        textAlignment: .center)
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        textField.delegate = self
        textField.placeholder = "example@mail.com"
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var continueButton: CustomButton = {
        
        let buttonAction = { [weak self] in
            guard let self = self else { return }
            
            self.`checkEmail`()
        }
        
        let button = CustomButton(title: "proceed".localized.uppercased(),
                                  backgroundColor: Palette.dynamicMonochromeButton,
                                  titleColor: Palette.dynamicTextInverted,
                                  action: buttonAction)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackIndicatorImage"), style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = Palette.dynamicMonochromeButton
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: Public methods
    
    func `continue`(email: String) {
        let enterPasswordViewController = EnterPasswordViewController(delegate: self.delegate, login: email)
        navigationController?.pushViewController(enterPasswordViewController, animated: true)
    }
    
    //MARK: Private methods
    
    private func setupSubviews() {
        view.backgroundColor = Palette.dynamicBackground
        
        view.addSubview(signUpLabel)
        view.addSubview(fillYourEmailLabel)
        view.addSubview(yourEmailWillBeUsedLabel)
        view.addSubview(loginTextField)
        view.addSubview(continueButton)
        
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            signUpLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100),
            signUpLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            signUpLabel.heightAnchor.constraint(equalToConstant: 50),
            
            fillYourEmailLabel.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 50),
            fillYourEmailLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            yourEmailWillBeUsedLabel.topAnchor.constraint(equalTo: fillYourEmailLabel.bottomAnchor, constant: 10),
            yourEmailWillBeUsedLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            yourEmailWillBeUsedLabel.widthAnchor.constraint(equalToConstant: 215),
                        
            loginTextField.topAnchor.constraint(equalTo: yourEmailWillBeUsedLabel.bottomAnchor, constant: 25),
            loginTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            loginTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),
            
            
            continueButton.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 16),
            continueButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
    
    private func checkEmail() {
        
        loginTextField.endEditing(true)
        
        guard let login = loginTextField.text,
              !login.isEmpty,
              !login.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            
            self.presentAlert(message: NSLocalizedString("pleaseFillEmail", comment: ""), feedBackType: .warning)
            return
        }
        
        guard isEmailFormat(login) else {
            self.presentAlert(message: "emailFormatInvalid".localized, feedBackType: .error)
            return
        }
        
        delegate?.signUpViewController(self, checkIfExists: login)
        
    }
    
    private func isEmailFormat(_ string: String) -> Bool {
        /// Method checks if a button is conforming example@mail.com format
    
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return  emailPredicate.evaluate(with: string)
    }
    
    // MARK: @Objc methods
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

// MARK: UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
    }
    
    
}
