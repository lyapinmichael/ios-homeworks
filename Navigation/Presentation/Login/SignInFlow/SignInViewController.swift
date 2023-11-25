//
//  LoginViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 14.11.2023.
//

import Foundation
import UIKit


// MARK: - SignInDelegate

protocol SignInDelegate: AnyObject {
    
    func signInViewController(_ signInViewController: SignInViewController, trySignIn email: String, password: String)
    
}

// MARK: - LoginViewController

final class SignInViewController: UIViewController {
    
    //    var testLogin = "furiousVader777@samplemail.com"
    //    var testPassword = "password"
    //
    //    var testLogin = "bimba@mail.com"
    //    var testPassword = "bimbaclack"
    //    
    
    weak var delegate: SignInDelegate?
    
    // MARK: Private properties
    
    private let localAuthorizationService = LocalAuthorizatoinService()
    private var viewModel = SignInViewModel()
    
    private var email: String = "" {
        didSet {
            loginTextField.text = email
        }
    }
    
    // MARK: Subviews
    
    private lazy var welcomeBackLabel: UILabel = {
        let label = UILabel()
        
        label.text = "welcomeBack".localized.uppercased()
        label.textColor = Palette.accentOrange
        label.font = .systemFont(ofSize: 18, weight: .medium, width: .standard)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fillLoginAndPasswordLabel: UILabel = {
        let label = UILabel()
        
        label.text = "fillEmailAndPassword".localized.uppercased()
        label.numberOfLines = 0
        label.textColor = UIColor.systemGray3
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginTextField: CustomTextField = {
        let textField = CustomTextField(autocapitalizationType: .none,
                                        returnKeyType: .done,
                                        textAlignment: .center)
        
        textField.placeholder = "fillEmail".localized
        textField.textContentType = .emailAddress
        
        textField.customDelegate = self
        
        textField.alpha = 1.0
        textField.isHidden = false
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(autocapitalizationType: .none,
                                        returnKeyType: .done,
                                        textAlignment: .center)
        
        textField.placeholder = "fillPassword".localized
        textField.textContentType = .password
        
        textField.addShowHideTextButton()
        
        textField.customDelegate = self
        
        textField.alpha = 0.0
        textField.isHidden = true
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var continueButton: CustomButton = {
        
        let buttonAction = { [weak self] in
            guard let self else { return }
            self.viewModel.updateState(with: .didTapContinueButton)
        }
        
        let button = CustomButton(title: "proceed".localized.uppercased(),
                                  backgroundColor: Palette.dynamicMonochromeButton, 
                                  titleColor: Palette.dynamicTextInverted,
                                  action: buttonAction)
        
        button.isEnabled = !email.isEmpty
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backButton: UIButton = {
        
        let buttonAction = UIAction { [weak self] _ in
            
        }
        
        let button = UIButton()
        button.setTitle("back".localized, for: .normal)
        button.setTitleColor(Palette.dynamicText, for: .normal)
        button.addAction(buttonAction, for: .touchUpInside)
        
        button.isHidden = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Init
    
    init(email: String, delegate: SignInDelegate) {
        self.email = email
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(delegate: SignInDelegate) {
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Palette.dynamicBackground
        setupSubviews()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: Private methods
    
    private func setupSubviews() {
        view.addSubview(welcomeBackLabel)
        view.addSubview(fillLoginAndPasswordLabel)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(continueButton)
        view.addSubview(backButton)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            welcomeBackLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100),
            welcomeBackLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            welcomeBackLabel.heightAnchor.constraint(equalToConstant: 50),
            
            fillLoginAndPasswordLabel.topAnchor.constraint(equalTo: welcomeBackLabel.bottomAnchor, constant: 50),
            fillLoginAndPasswordLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            fillLoginAndPasswordLabel.widthAnchor.constraint(lessThanOrEqualTo: safeArea.widthAnchor, constant: -32),
            
            loginTextField.topAnchor.constraint(equalTo: fillLoginAndPasswordLabel.bottomAnchor, constant: 25),
            loginTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            loginTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.topAnchor, constant: 66),
            passwordTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            continueButton.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 16),
            continueButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 16)
            
        ])
    }
    
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .waitingForEmail:
                self.showLoginTextField()
                self.continueButton.setBackgroundColor(Palette.dynamicMonochromeButton)
                self.continueButton.setTitle("proceed".localized.uppercased(), for: .normal)
                self.continueButton.setTitleColor(Palette.dynamicTextInverted)
                
            case .emailFormatInvalid:
                self.presentAlert(message: "emailFormatInvalid".localized, feedBackType: .error) {
                    self.viewModel.updateState(with: .didTapCloseAlert)
                }
                
            case .waitigForPassword:
                self.passwordTextField.text = nil
                self.continueButton.isEnabled = false
                self.showPasswordTextField()
                self.continueButton.setBackgroundColor(Palette.accentOrange)
                self.continueButton.setTitle("signIn".localized.uppercased(), for: .normal)
                self.continueButton.setTitleColor(UIColor.white)
                
            case .trySignIn(let email, let password):
                delegate?.signInViewController(self, trySignIn: email, password: password)
                
            case .wrongPassword:
                return
            }
        }
    }
    
    private func showPasswordTextField() {
        
        loginTextField.endEditing(true)
        passwordTextField.isHidden = false
        
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self else { return }
            self.loginTextField.transform = CGAffineTransform(translationX: 0, y: -50)
            self.loginTextField.alpha = 0
            
            self.passwordTextField.transform = CGAffineTransform(translationX: 0, y: -66)
            self.passwordTextField.alpha = 1
            
            
        } completion: { [weak self] _ in
            guard let self else { return }
            
            self.loginTextField.isHidden = true
        }
    }
    
    private func showLoginTextField() {
        
        guard loginTextField.isHidden else { return }
        
        loginTextField.isHidden = false
        
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self else { return }
            self.loginTextField.transform = CGAffineTransform(translationX: 0, y: 0)
            self.loginTextField.alpha = 1
            
            self.passwordTextField.transform = CGAffineTransform(translationX: 0, y: +0)
            self.passwordTextField.alpha = 0
            
            
        } completion: { [weak self] _ in
            guard let self else { return }
            
            self.passwordTextField.isHidden = true
        }
    }
    
    
}

// MARK: - CustomTextFieldDelegate

extension SignInViewController: CustomTextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeEditing(_ textField: CustomTextField) {
        
        if textField == loginTextField {
            if let email = textField.text,
               !email.isEmpty,
               !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                
                viewModel.updateState(with: .didChangeEmailEditing(email))
                continueButton.isEnabled = true
                
            } else {
                continueButton.isEnabled = false
            }
        }
        
        
        if textField == passwordTextField {
            if  let password = textField.text,
                !password.isEmpty,
                !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                password.count >= 6 {
                
                viewModel.updateState(with: .didChangePasswordEditing(password))
                continueButton.isEnabled = true
                
            } else {
                continueButton.isEnabled = false
            }
        }
    }
    
    
}
