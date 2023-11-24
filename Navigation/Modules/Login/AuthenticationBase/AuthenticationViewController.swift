//
//  LogInViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 22.02.2023.
//

import UIKit
import FirebaseAuth

// MARK: - AuthenticationViewController

final class AuthenticationViewController: UIViewController {
    
    // MARK: Public properties
    
    weak var coordinator: LoginCoordinator?
    
    // MARK: Private properties
    
    private var viewModel = AuthenticationViewModel()
    
    // MARK: Subviews
    
    private lazy var logoImage: UIImageView = {
        let logo = UIImageView(frame: CGRect(x: .zero, y: .zero, width: 100.0, height: 100.0))
        logo.image = UIImage(named: "Logo")
        
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        return logo
    }()
    
    private lazy var signInButton: UIButton = {
        
        let buttonAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            let loginViewController = SignInViewController(delegate: self)
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
        
        let logInString = "alreadyHaveAnAccount".localized
        let button = UIButton()
        button.setTitle(logInString, for: .normal)
        button.setTitleColor(Palette.dynamicText, for: .normal)
        button.addAction(buttonAction, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var signUpButton: CustomButton = {
        
        let buttonAction = { [weak self] in
            guard let self = self else { return }
            
            let signupController = SignUpViewController()
            signupController.delegate = self
            self.navigationController?.pushViewController(signupController, animated: true)
        }
        
        let signUp = NSLocalizedString("signUp", comment: "")
        let button = CustomButton(title: signUp, backgroundColor: Palette.dynamicMonochromeButton, titleColor: Palette.dynamicTextInverted, action: buttonAction, isFeedbackEnabled: true)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        bindViewModel()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackIndicatorImage"), style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = Palette.dynamicMonochromeButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = Palette.dynamicBackground
        
    }
    
    // MARK: Private methods
    
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .initial:
                return
                
            case .didLogIn(let user):
                self.coordinator?.proceedToMain(user)
                return
                
            case .failedToLogIn(let error):
                self.presentAlert(message: "failedToSignIn".localized)
                print(error)
                
            case .emailAlreadyExists(let email):
                self.presentAlert(message: "emailAlreadyExists".localized,
                                   actionTitle: "signIn".localized,
                                   feedBackType: .error,
                                   addCancelAction: true) {
                    
                    let loginViewController = SignInViewController(email: email, delegate: self)
                    self.navigationController?.pushViewController(loginViewController, animated: true)
                }
                
            case .didSignUp(let user):
                self.presentedViewController?.dismiss(animated: true)
                self.presentAlert(message: NSLocalizedString("registrationSuccessfull", comment: ""), actionTitle: "begin".localized) {
                    
                    self.coordinator?.proceedToMain(user)
                    print("Logging in...")
                    return
                }
                
            case .failedToSignUp(let error):
                self.presentAlert(message: error.localizedDescription)
                print(error)
                
            }
        }
    }

    private func setupSubviews() {
        
        view.addSubview(signUpButton)
        view.addSubview(signInButton)
        view.addSubview(logoImage)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            logoImage.heightAnchor.constraint(equalToConstant: 344),
            logoImage.widthAnchor.constraint(equalToConstant: 344),
            logoImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 86),
            logoImage.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 46),
            signUpButton.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 72),
            signUpButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 260),
            
            signInButton.heightAnchor.constraint(equalToConstant: 40),
            signInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 22),
            signInButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
    
    
}

// MARK: - SignUpDelegate 

extension AuthenticationViewController: SignUpDelegate {
 
  
    func signUpViewController(trySignUp email: String, password: String, fullName: String) {
        viewModel.updateState(with: .trySignUp(login: email,
                                               password: password,
                                               fullName: fullName))

    }
    
   
    func signUpViewController(_ signUpViewController: SignUpViewController, checkIfExists email: String) {
        viewModel.updateState(with: .checkNotExists(email: email)) {
            signUpViewController.continue(email: email)
        }
    }
    
    
}

extension AuthenticationViewController: SignInDelegate {
   
    func signInViewController(_ signInViewController: SignInViewController, trySignIn email: String, password: String) {
        viewModel.updateState(with: .trySignIn(login: email, password: password))
    }
    
    
}
