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
    
    weak var coordinator: ProfileCoordinator?
    private var loginDelegate: LogInViewControllerDelegate?
    
    var testLogin = "furiousVader777@samplemail.com"
    var testPassword = "password"
    
    // MARK: - Private properties
    
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
            signupController.signupDelegate = loginDelegate
            self.present(signupController, animated: true)
        }
        
        let signUp = NSLocalizedString("signUp", comment: "")
        let button = CustomButton(title: signUp, color: UIColor(named: "ColorSet"), action: buttonAction)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    

    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginDelegate = LoginInspector()
        
        setup()
        addSubviews()
        setConstraints()
        addContentSubviews()
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
    
    // MARK: - Public methods
    
    func login(login: String, password: String) {
        loginDelegate?.checkCredentials(email: login, password: password) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success((let userEmail, let userName)):
                guard let email = userEmail else {
                    assertionFailure("Bad email. Check auth settings.")
                    return
                }
        
                self.coordinator?.proceedToProfile(User(login: email, fullName: userName ?? "DefaultUsername"))
                
            case .failure(let error):
                
                self.presentAlert(message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func setup() {
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        
    }
    
    private func setConstraints() {
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
    
    private func addContentSubviews() {
        contentView.addSubview(logoImage)
        contentView.addSubview(loginView)
        contentView.addSubview(showHideTextButton)
        contentView.addSubview(loadingSpinner)
        contentView.addSubview(loginButton)
        contentView.addSubview(signUpButton)
       
        
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

            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    
        ])
    }
    
    private func tryLogin() {
        
        loginField.endEditing(true)
        passwordField.endEditing(true)
        
        guard let login = loginField.text, !login.isEmpty else {
            presentAlert(message: NSLocalizedString("pleaseFillLogin", comment: ""))
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            presentAlert(message: NSLocalizedString("pleaseFillLogin", comment: ""))
            return
        }
        
        self.login(login: login, password: password)
   
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


extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
