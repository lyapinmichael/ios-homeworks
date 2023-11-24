//
//  EnterFullNameViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 14.11.2023.
//

import UIKit

// MARK: - EnterPasswordViewController

class EnterPasswordViewController: UIViewController {
    
    // MARK: Public properties
    
    weak var delegate: SignUpDelegate?
    
    // MARK: Private properties
    
    private let viewModel = EnterPasswordViewModel()
    
    private let login: String
    
    // MARK: Subviews
    
    private lazy var createPasswordLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium, width: .standard)
        label.textAlignment = .center
        
        let labelText = "\( "create".localized) \( "secure".localized) \( "password".localized)".uppercased()
        
        let attributedText = NSMutableAttributedString(string: labelText)
        
        let create = (labelText as NSString).range(of: "create".localized.uppercased())
        attributedText.addAttribute(.foregroundColor, value: Palette.dynamicText, range: create)
        
        let secure = (labelText as NSString).range(of: "secure".localized.uppercased())
        attributedText.addAttribute(.foregroundColor, value: Palette.accentOrange, range: secure)
        
        let password = (labelText as NSString).range(of: "password".localized.uppercased())
        attributedText.addAttribute(.foregroundColor, value: Palette.dynamicText, range: password)
        
        label.attributedText = attributedText
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordLengthLabel: UILabel = {
       let label = UILabel()
        
        label.numberOfLines = 0
        label.text = "passwordLengthRestriction".localized
        label.textAlignment = .center
        label.textColor = UIColor.systemGray3
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var passwordField: CustomTextField = makePasswordTextField()
    
    private lazy var repeatPasswordField: CustomTextField = makePasswordTextField(isHidden: true, withAlphaComponent: 0.0)
    
    private lazy var repeatPasswordOrContinueButton: CustomButton = {
        
        let buttonAction = { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.updateState(with: .buttonDidTap)
        }
        
        let button = CustomButton(title: "repeatPassword".localized.uppercased(),
                                  backgroundColor: Palette.dynamicMonochromeButton,
                                  titleColor: Palette.dynamicTextInverted,
                                  action: buttonAction)
        
        button.isEnabled = false
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Init
    
    init(delegate: SignUpDelegate?, login: String) {
        self.delegate = delegate
        self.login = login
        
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
        bindViewModel()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackIndicatorImage"), style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = Palette.dynamicMonochromeButton
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: Private methods
    
    private func setupSubviews() {
        view.addSubview(createPasswordLabel)
        view.addSubview(passwordLengthLabel)
        view.addSubview(passwordField)
        view.addSubview(repeatPasswordOrContinueButton)
        view.addSubview(repeatPasswordField)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            createPasswordLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100),
            createPasswordLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            createPasswordLabel.heightAnchor.constraint(equalToConstant: 50),
            
            passwordLengthLabel.topAnchor.constraint(equalTo: createPasswordLabel.bottomAnchor, constant: 50),
            passwordLengthLabel.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -32),
            passwordLengthLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            passwordField.topAnchor.constraint(equalTo: passwordLengthLabel.bottomAnchor, constant: 25),
            passwordField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            passwordField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            passwordField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            repeatPasswordField.topAnchor.constraint(equalTo: passwordField.topAnchor, constant: 66),
            repeatPasswordField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            repeatPasswordField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            repeatPasswordField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            repeatPasswordField.heightAnchor.constraint(equalToConstant: 50),
            
            repeatPasswordOrContinueButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16),
            repeatPasswordOrContinueButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
            
        ])
    }
    
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .waitingForPassword:
                self.showPasswordTextField()
                self.passwordField.text = nil
                self.repeatPasswordOrContinueButton.setTitle("repeatPassword".localized.uppercased(), for: .normal)
                self.repeatPasswordOrContinueButton.isEnabled = false
                
            case .waitingToRepeatPassword:
                self.repeatPasswordOrContinueButton.setTitle("proceed".localized.uppercased(), for: .normal)
                self.repeatPasswordOrContinueButton.isEnabled = false
                self.showRepeatPasswordTextField()
                self.repeatPasswordField.text = nil
                
            case .passwordContainsWhitespaces:
                self.presentAlert(message: "passwordShouldNotHaveWhitespaces".localized,
                                  title: "oops".localized,
                                  feedBackType: .error)
                self.passwordField.text = nil
                
            case .passwordLegthValid:
                self.repeatPasswordOrContinueButton.setTitle("repeatPassword".localized.uppercased(), for: .normal)
                self.repeatPasswordOrContinueButton.isEnabled = true
                
            case .passwordTooShort:
                self.repeatPasswordOrContinueButton.setTitle("repeatPassword".localized.uppercased(), for: .normal)
                self.repeatPasswordOrContinueButton.isEnabled = false
                
            case .passwordsDoNotMatch:
                self.presentAlert(message: "passwordsComparisonFail".localized, feedBackType: .error) {
                    self.viewModel.updateState(with: .alertButtonDidTap)
                }
                
            case .passwordsValidAndMatch(let password):
                self.continue(password: password)
                
            case .waitingToComparePasswords:
                self.repeatPasswordOrContinueButton.setTitle("proceed".localized.uppercased(), for: .normal)
                self.repeatPasswordOrContinueButton.isEnabled = true
                
            }
        }
    }
    
    private func showRepeatPasswordTextField() {
        
        passwordField.endEditing(true)
        repeatPasswordField.isHidden = false
        
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self else { return }
            self.passwordField.transform = CGAffineTransform(translationX: 0, y: -50)
            self.passwordField.alpha = 0
            
            self.repeatPasswordField.transform = CGAffineTransform(translationX: 0, y: -66)
            self.repeatPasswordField.alpha = 1
            
            
        } completion: { [weak self] _ in
            guard let self else { return }
            
            self.passwordField.isHidden = true
        }
    }
    
    private func showPasswordTextField() {
        
        guard passwordField.isHidden else { return }
        
        passwordField.isHidden = false
        
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self else { return }
            self.passwordField.transform = CGAffineTransform(translationX: 0, y: 0)
            self.passwordField.alpha = 1
            
            self.repeatPasswordField.transform = CGAffineTransform(translationX: 0, y: +0)
            self.repeatPasswordField.alpha = 0
            
            
        } completion: { [weak self] _ in
            guard let self else { return }
            
            self.repeatPasswordField.isHidden = true
        }
        
    }
    
    private func `continue`(password: String) {
        
        passwordField.endEditing(true)
        
        let enterDisplayNameViewController = EnterDisplayNameViewController(login: self.login, password: password, delegate: self.delegate)
        navigationController?.pushViewController(enterDisplayNameViewController, animated: true)
    }
    
    
    private func makePasswordTextField(isHidden: Bool = false, withAlphaComponent alpha: CGFloat = 1.0) -> CustomTextField {
        /// This method is used to create muiltiple identical UITextFields without
        ///  redeclaring them in a corresponding property.
        
        let textField = CustomTextField(autocapitalizationType: .none,
                                        returnKeyType: .done,
                                        textAlignment: .center)
        
        textField.placeholder = "fillPassword".localized
        
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.returnKeyType = .next
        
        textField.rightView = makeShowHideTextButtonView(for: textField)
        textField.rightViewMode = .always
        
        textField.customDelegate = self
        
        textField.alpha = alpha
        textField.isHidden = isHidden
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    private func makeShowHideTextButtonView(for uiTextField: UITextField) -> UIView {
        /// This method is used to create muiltiple identical UIButtons without
        ///  redeclaring them in a corresponding property.
        ///  It is returning a view as it is expected for button to be padded
        ///  from the edge of text field, if it is added to a text field as a
        ///  right view
        
        let button = UIButton(type: .system)
        
        let setButtonImage = {
            let image = uiTextField.isSecureTextEntry ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
            button.setImage(image, for: .normal)
        }
        
        let action = UIAction { _ in
            
            uiTextField.isSecureTextEntry.toggle()
            setButtonImage()
        }
        
        setButtonImage()
        button.addAction(action, for: .touchUpInside)
        button.tintColor = Palette.accentOrange
        
        let buttonSize = button.intrinsicContentSize
        
        let containerView = UIView(frame: CGRect(x: .zero,
                                                 y: .zero,
                                                 width: buttonSize.width + 16,
                                                 height: buttonSize.height))
        
        button.frame = CGRect(x: .zero,
                              y: .zero,
                              width: buttonSize.width,
                              height: buttonSize.height)
        
        containerView.addSubview(button)
        return containerView
    }
    
    // MARK: @Objc methods
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

// MARK: - UITextFieldDelegate

extension EnterPasswordViewController: CustomTextFieldDelegate {
    
    func textFieldDidChangeEditing(_ textField: CustomTextField) {
        
        if textField == passwordField {
            viewModel.updateState(with: .passwordDidChangeEnditing(textField.text))
        } else if textField == repeatPasswordField {
            viewModel.updateState(with: .repeatPasswordDidChangeEnditing(textField.text))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
    }
    
    
}
