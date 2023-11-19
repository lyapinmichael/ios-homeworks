//
//  LoginViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 14.11.2023.
//

import Foundation
import UIKit

// MARK: - LoginViewController

final class LoginViewController: UIViewController {
    
//    //    var testLogin = "furiousVader777@samplemail.com"
//    //    var testPassword = "password"
//    
    var testLogin = "bimba@mail.com"
    var testPassword = "bimbaclack"
    
    let localAuthorizationService = LocalAuthorizatoinService()

    var email: String = ""
    
    // MARK: Subviews
    
    private lazy var biometricAuthorizationButton: UIButton = {
        let button = UIButton()
        
        let imageName = localAuthorizationService.biometryType.imageSystemName
        button.setBackgroundImage(UIImage(systemName: imageName), for: .normal)
        
//        let action = UIAction { [weak self] _ in
//
//            self?.localAuthorizationService.authorizeIfPossible { [weak self] success, error  in
//                if success {
//                    guard let self = self else { return }
//
//                    // TODO: Refactor to open if user had ever successfully logged in
//                    self.viewModel.updateState(with: .tryLogIn(login: testLogin, password: testPassword))
//                } else {
//
//                    DispatchQueue.main.async {
//
//                        let title = "errorOccured".localized
//                        let message = error?.localizedDescription
//                        let alertController = UIAlertController(title: title,
//                                                                message: message,
//                                                                preferredStyle: .alert)
//                        let action = UIAlertAction(title: "close".localized,
//                                                   style: .destructive) { _ in
//                            alertController.dismiss(animated: true)
//                        }
//                        alertController.addAction(action)
//
//                        self?.present(alertController, animated: true)
//                    }
//                }
//            }
//
//        }
//
//        button.addAction(action, for: .touchUpInside)
        
        if case .none  =  localAuthorizationService.biometryType {
            button.isHidden = true
        }
        
        button.isEnabled = localAuthorizationService.isBiometryAuthorizationAvailable
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
//    private lazy var loginField: UITextField = { [unowned self] in
//        let textField = CustomTextField()
//        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        textField.placeholder = "Email"
//        textField.autocapitalizationType = .none
//        textField.returnKeyType = .done
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.delegate = self
//        
//        /// Default login to be deleted later:
//        textField.text = testLogin
//        return textField
//    }()
//    
//    private lazy var passwordField: UITextField = {
//        let textField = CustomTextField()
//        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        textField.placeholder = NSLocalizedString("password", comment: "")
//        textField.textContentType = .oneTimeCode
//        textField.autocapitalizationType = .none
//        textField.isSecureTextEntry = true
//        textField.returnKeyType = .done
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.delegate = self
//        
//        /// Default password to be deleted later:
//        textField.text = testPassword
//        return textField
//    }()
//    
//    private lazy var showHideTextButton: UIButton = {
//        let action = UIAction { [weak self] action in
//            guard let self = self else { return }
//            
//            self.passwordField.isSecureTextEntry.toggle()
//            
//            switch self.passwordField.isSecureTextEntry {
//            case true:
//                self.showHideTextButton.setImage(UIImage(systemName: "eye"), for:.normal)
//            case false:
//                self.showHideTextButton.setImage(UIImage(systemName: "eye.slash"), for:.normal)
//            }
//        }
//        
//        let button = UIButton(primaryAction: action)
//        button.setImage(UIImage(systemName: "eye"), for: .normal)
//        
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    private lazy var loadingSpinner: UIActivityIndicatorView = {
//        let spinner = UIActivityIndicatorView(style: .medium)
//        spinner.isHidden = true
//        spinner.hidesWhenStopped = true
//        
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        return spinner
//    }()
//    
//    private lazy var loginView: UIStackView = {
//        let view = UIStackView()
//        view.backgroundColor = Palette.dynamicTextfield
//        
//        view.layer.borderColor = UIColor.lightGray.cgColor
//        view.layer.borderWidth = 0.3
//        view.layer.cornerRadius = 10
//        view.tintColor = UIColor(named: "ColorSet")
//        
//        view.axis = .vertical
//        view.distribution = .fillProportionally
//        view.spacing = 0.0
//        
//        let separator = UIView()
//        separator.backgroundColor = .lightGray
//        separator.heightAnchor.constraint(equalToConstant: 0.3).isActive = true
//        separator.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addArrangedSubview(loginField)
//        view.addArrangedSubview(separator)
//        view.addArrangedSubview(passwordField)
//        
//        view.translatesAutoresizingMaskIntoConstraints = false
//        
//        return view
//    }()
//    
    // MARK: Init
    
    init(email: String) {
        self.email = email
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemYellow
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
//    // Following methods make view scroll whenever keyboard appears,
//    // so that taxtFields are not blocked.
//    private func setKeyboardObservers() {
//        let notificationCenter = NotificationCenter.default
//        
//        notificationCenter.addObserver(
//            self,
//            selector: #selector(self.willShowKeyboard(_:)),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil
//        )
//        
//        notificationCenter.addObserver(
//            self,
//            selector: #selector(self.willHideKeyboard(_:)),
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil
//        )
//    }
//    
//    private func removeKeyboardObservers() {
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.removeObserver(self)
//    }
//    
//    private func tryLogin() {
//        
//        loginField.endEditing(true)
//        passwordField.endEditing(true)
//        
//        guard let login = loginField.text, !login.isEmpty else {
//            presentAlert(message: NSLocalizedString("pleaseFillLogin", comment: ""))
//            return
//        }
//        
//        guard let password = passwordField.text, !password.isEmpty else {
//            presentAlert(message: NSLocalizedString("pleaseFillPassword", comment: ""))
//            return
//        }
//        
//        viewModel.updateState(with: .tryLogIn(login: login, password: password))
//    }
//    
//    
//    // MARK: @Objc Actions
//    
//    @objc private func willShowKeyboard(_ notification: NSNotification) {
//        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
//            return
//        }
//        
//        if contentView.frame.height > keyboardHeight {
//            scrollView.contentInset.bottom = keyboardHeight
//        }
//    }
//    
//    @objc func willHideKeyboard(_ notification: NSNotification) {
//        scrollView.contentInset.bottom = 0.0
//    }
    
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
