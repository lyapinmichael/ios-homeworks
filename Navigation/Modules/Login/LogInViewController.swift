//
//  LogInViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 22.02.2023.
//

import UIKit
import FirebaseAuth

// MARK: - LogInViewController: UIViewController()

final class LogInViewController: UIViewController {
    
    // MARK: - Public properties
    
    weak var coordinator: LoginCoordinator?
    
    let localAuthorizationService = LocalAuthorizatoinService()
    
//    var testLogin = "furiousVader777@samplemail.com"
//    var testPassword = "password"
    
    var testLogin = "bimba@mail.com"
    var testPassword = "bimbaclack"
    
    // MARK: - Private properties
    
    private var viewModel = AuthenticationViewModel()
    
    // MARK: - Subviews
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = Palette.dynamicBackground
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        view.backgroundColor = Palette.dynamicBackground
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var logoImage: UIImageView = {
        let logo = UIImageView(frame: CGRect(x: .zero, y: .zero, width: 100.0, height: 100.0))
        logo.image = UIImage(named: "VKLogo")
        
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        return logo
    }()
    
    private lazy var loginField: UITextField = { [unowned self] in
        let textField = CustomTextField()
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.placeholder = "Email"
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        /// Default login to be deleted later:
        textField.text = testLogin
        return textField
    }()
    
    private lazy var passwordField: UITextField = {
        let textField = CustomTextField()
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.placeholder = NSLocalizedString("password", comment: "")
        textField.textContentType = .oneTimeCode
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        /// Default password to be deleted later:
        textField.text = testPassword
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
    
    private lazy var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.isHidden = true
        spinner.hidesWhenStopped = true
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
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
        
        view.addArrangedSubview(loginField)
        view.addArrangedSubview(separator)
        view.addArrangedSubview(passwordField)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var loginButton: CustomButton = {
        
        let buttonAction = {[weak self] in
            guard let self = self else { return }
            self.tryLogin()
        }
        
        let logInString = NSLocalizedString("signIn", comment: "")
        let button = CustomButton(title: logInString, color: UIColor(named: "ColorSet"), action: buttonAction)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var signUpButton: CustomButton = {
       
        let buttonAction = { [weak self] in
            guard let self = self else { return }
            
            let signupController = SignUpViewController()
            signupController.delegate = self
            self.present(signupController, animated: true)
        }
        
        let signUp = NSLocalizedString("signUp", comment: "")
        let button = CustomButton(title: signUp, color: UIColor(named: "ColorSet"), action: buttonAction)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var biometricAuthorizationButton: UIButton = {
       let button = UIButton()
        
        let imageName = localAuthorizationService.biometryType.imageSystemName
        button.setBackgroundImage(UIImage(systemName: imageName), for: .normal)
        
        let action = UIAction { [weak self] _ in
            
            self?.localAuthorizationService.authorizeIfPossible { [weak self] success, error  in
                if success {
                    guard let self = self else { return }
                    
                    // TODO: Refactor to open if user had ever successfully logged in
                    self.viewModel.updateState(with: .tryLogIn(login: testLogin, password: testPassword))
                } else {

                    DispatchQueue.main.async {
                        
                        let title = "errorOccured".localized
                        let message = error?.localizedDescription
                        let alertController = UIAlertController(title: title,
                                                                message: message,
                                                                preferredStyle: .alert)
                        let action = UIAlertAction(title: "close".localized,
                                                   style: .destructive) { _ in
                            alertController.dismiss(animated: true)
                        }
                        alertController.addAction(action)
                        
                        self?.present(alertController, animated: true)
                    }
                }
            }
            
        }
        
        button.addAction(action, for: .touchUpInside)
        
        if case .none  =  localAuthorizationService.biometryType {
            button.isHidden = true
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupSubviews()
        addContentSubviews()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        setKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    // MARK: - Private methods
    
    // Method to set up apperance of root view.
    private func setup() {
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
    }
    
    // MARK:  Bind viewModel
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            switch state {
            case .initial:
                return
                
            case .didLogIn(let user):
                self?.coordinator?.proceedToMain(user)
                return
           
            case .failedToLogIn(let error):
                self?.presentAlert(message: "Failed to log in")
                print(error)
                
            case .didSignUp(let user):
                self?.presentedViewController?.dismiss(animated: true)
                self?.presentAlert(message: NSLocalizedString("registrationSuccessfull", comment: "")) { 
                    
                    self?.coordinator?.proceedToMain(user)
                    print("Logging in...")
                    return
                }
               
                
            case .failedToSignUp(let error):
                self?.presentAlert(message: error.localizedDescription)
                print(error)
                
            }
        }
    }
        
    // Mark following methods set up subviews.
    private func setupSubviews() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.heightAnchor.constraint(equalTo: safeArea.heightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func addContentSubviews() {
        contentView.addSubview(logoImage)
        contentView.addSubview(loginView)
        contentView.addSubview(showHideTextButton)
        contentView.addSubview(loadingSpinner)
        contentView.addSubview(loginButton)
        contentView.addSubview(signUpButton)
        contentView.addSubview(biometricAuthorizationButton)
        
        NSLayoutConstraint.activate([
            logoImage.heightAnchor.constraint(equalToConstant: 100),
            logoImage.widthAnchor.constraint(equalToConstant: 100),
            logoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginView.heightAnchor.constraint(equalToConstant: 100),
            loginView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 120),
            loginView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            showHideTextButton.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor),
            showHideTextButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: -8),
            showHideTextButton.heightAnchor.constraint(equalTo: passwordField.heightAnchor, constant: -4),
            
            loadingSpinner.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor),
            loadingSpinner.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor, constant: -12),
            
            biometricAuthorizationButton.heightAnchor.constraint(equalToConstant: 44),
            biometricAuthorizationButton.widthAnchor.constraint(equalToConstant: 44),
            biometricAuthorizationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            biometricAuthorizationButton.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),

            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: biometricAuthorizationButton.leadingAnchor, constant: -16),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    
        ])
    }
    
    // Following methods make view scroll whenever keyboard appears,
    // so that taxtFields are not blocked.
    private func setKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    private func tryLogin() {
        
        loginField.endEditing(true)
        passwordField.endEditing(true)
        
        guard let login = loginField.text, !login.isEmpty else {
            presentAlert(message: NSLocalizedString("pleaseFillLogin", comment: ""))
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            presentAlert(message: NSLocalizedString("pleaseFillPassword", comment: ""))
            return
        }
        
        viewModel.updateState(with: .tryLogIn(login: login, password: password))
    }
    
        
    // MARK: - @Objc Actions
    
    @objc private func willShowKeyboard(_ notification: NSNotification) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
            return
        }
        
        if contentView.frame.height > keyboardHeight {
            scrollView.contentInset.bottom = keyboardHeight
        }
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0.0
    }
    
}

// MARK: -  LogInViewController: SignUpDelegate extension

extension LogInViewController: SignUpDelegate {
    func trySignUp(email: String, password: String, fullName: String) {
        viewModel.updateState(with: .trySignUp(login: email,
                                               password: password,
                                               fullName: fullName))
    }
    
   
}

extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
