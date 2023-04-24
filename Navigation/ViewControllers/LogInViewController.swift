//
//  LogInViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 22.02.2023.
//

import UIKit

//MARK: - LogInViewControllerDelegate Protocol

protocol LogInViewControllerDelegate {
    func check(login: String, password: String) -> Bool
}

// MARK: - LogInViewController: UIViewController()

final class LogInViewController: UIViewController {
    
    // MARK: - Public properties
    
    var loginDelegate: LogInViewControllerDelegate?
    
    // MARK: - Private properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
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
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.placeholder = "Email or phone"
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        /// Default login to be deleted later:
        textField.text = "furiousVader66"
        return textField
    }()
    
    private lazy var passwordField: UITextField = {
        let textField = CustomTextField()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.placeholder = "Password"
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        /// Default password to be deleted later:
        textField.text = "isThisPasswordStrongEnough?"
        return textField
    }()
    
    private lazy var loginView: UIStackView = {
        let view = UIStackView()
        view.layer.backgroundColor = UIColor.systemGray6.cgColor
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
        let button = CustomButton(title: "Log in", color: UIColor(named: "ColorSet"))
        
        button.buttonAction = {[weak self] in
            self?.login()
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addSubviews()
        setConstraints()
        addContentSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
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
        contentView.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            logoImage.heightAnchor.constraint(equalToConstant: 100),
            logoImage.widthAnchor.constraint(equalToConstant: 100),
            logoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginView.heightAnchor.constraint(equalToConstant: 100),
            loginView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 120),
            loginView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func login() {
        guard var viewControllers = navigationController?.viewControllers else { return }
        
        loginField.endEditing(true)
        passwordField.endEditing(true)
        
        let login = loginField.text ?? ""
        let password = passwordField.text ?? ""
        
        /// Closure, that checks password and login, and handles exceptions
        
        let checkLoginPassword = { [self] (login: String?, password: String?) throws in
           
            guard login != nil && login != "" else { throw LoginInspectorErrors.emptyLogin }
            
            guard password != nil && password != "" else { throw LoginInspectorErrors.emptyPassword }
            
            let userService: UserService
            
            userService = CurrentUserService()
            
            guard let authorisedUser = userService.authorize(login: login!) else { throw LoginInspectorErrors.loginNotRegistered }
            
            if loginDelegate!.check(login: login!, password: password!) {
                
                
                _ = viewControllers.popLast()
                
                viewControllers.append(ProfileViewController(with: authorisedUser))
                navigationController?.setViewControllers(viewControllers, animated: true)
            } else { throw LoginInspectorErrors.wrongLoginOrPassword }
        }
        
        /// Closure, that shows alert message
        
        let showAlert = { (message: String) -> Void in
            
            let alert = UIAlertController(title: "Authorization error",
                                          message: message,
                                          preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "Close",
                                              style: .cancel)
            
            alert.addAction(dismissAction)
            
            self.present(alert,
                         animated: true,
                         completion: {self.loginField.text = nil})
            
        }
        
        /// Main logic of function
        
        do {
            try checkLoginPassword(login, password)
        } catch LoginInspectorErrors.emptyLogin {
            showAlert("Please enter registered login")
        } catch LoginInspectorErrors.emptyPassword {
            showAlert("Please enter password")
        } catch LoginInspectorErrors.loginNotRegistered {
            showAlert("User with login \(login) not registered")
        } catch LoginInspectorErrors.wrongLoginOrPassword {
            showAlert("Wrong login or password")
        } catch {
            showAlert("Unknow error occured")
        }
        

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
