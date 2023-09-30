//
//  FeedViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 10.02.2023.
//

import UIKit
import StorageService

protocol FeedView {
    
    func presentAlertOnGuess(isRight flag: Bool)

}

final class FeedViewController: UIViewController, FeedView {

    // MARK: - Public properties
    
    weak var coordinator: FeedCoordinator?
    
    // MARK: - Private properties
  
    private let viewModel = FeedViewModel()
    
    private lazy var stackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var  button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("openPost", comment: ""), for: .normal)

        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var guesserTextField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = Palette.dynamicTextfield
        textField.placeholder = NSLocalizedString("correctWord", comment: "") + "discombobulate"
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private lazy var checkGuessButton: CustomButton = {
       
        let buttonAction = { [weak self] in
            
            self?.guesserTextField.endEditing(true)
            
            guard let text = self?.guesserTextField.text else { return }
            guard text != "" else {
                self?.alertOnEmptyGuess()
                return
            }
            self?.viewModel.updateState(withInput: .didTapCheckGuessButton(word: text))
            
        }
        
        let button = CustomButton(title: NSLocalizedString("check", comment: ""), color: UIColor(named: "ColorSet"), action: buttonAction)
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }()
    
    private lazy var checkResultLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("nothingWasChecked", comment: "")
        label.textColor = .gray
        
        return label
    }()
    
    private lazy var barButtonItem: UIBarButtonItem = {
        var barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "info.circle")
        barButton.target = self
        barButton.action = #selector(barButtronPressed(_:))
        return barButton
    }()
    // MARK: - Private methods
    
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            switch state {
            case .initial:
                return
            case .didCheckGuess(let flag):
                self?.presentAlertOnGuess(isRight: flag)
            }
            
        }
    }

    private func setupStackView() {
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
            
        ])
        
        stackView.addArrangedSubview(checkResultLabel)
        stackView.addArrangedSubview(guesserTextField)
        stackView.addArrangedSubview(checkGuessButton)
        stackView.addArrangedSubview(button)
    }
    
    
    ///Method presents an alert if button was pressed but no text was entered
    private func alertOnEmptyGuess() {
        let message = NSLocalizedString("enterSomething", comment: "")
        
        let alert = UIAlertController(title: NSLocalizedString("oops", comment: ""),
                                      message: message,
                                      preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: NSLocalizedString("close", comment: ""),
                                          style: .cancel)
        
        alert.addAction(dismissAction)
        
        self.present(alert,
                     animated: true,
                     completion: {self.guesserTextField.text = nil})
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.feedView = self
        bindViewModel()
        
        title = NSLocalizedString("feed", comment: "")
    
        view.backgroundColor = Palette.dynamicBackground
    
        navigationItem.rightBarButtonItem = barButtonItem
        
        view.addSubview(stackView)
        setupStackView()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
        
    }
    
    //MARK: - ObjcMethods
    
    @objc func buttonPressed (_ sender: UIButton) {
        
     
        coordinator?.present(.post)
    
    }
    
    @objc func dismissKeyboard () {
        guesserTextField.endEditing(true)
        
    }
    
    
    @objc private func barButtronPressed(_ sender: UIBarButtonItem) {
        
        coordinator?.present(.info)
        
    }
    
    // MARK: Check button action
    func presentAlertOnGuess(isRight flag: Bool) {
        
        let message: String
        switch flag {
        case true:
            message = NSLocalizedString("rightGuess", comment: "")
            checkResultLabel.text = NSLocalizedString("right", comment: "")
            checkResultLabel.textColor = .green
        case false:
            message = NSLocalizedString("wrongGuess", comment: "")
            checkResultLabel.text = NSLocalizedString("wrong", comment: "")
            checkResultLabel.textColor = .red
        }
        
        let alert = UIAlertController(title: NSLocalizedString("guessWasChecked", comment: ""),
                                      message: message,
                                      preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: NSLocalizedString("close", comment: ""),
                                          style: .cancel)
        
        alert.addAction(dismissAction)
        
        self.present(alert,
                     animated: true,
                     completion: {self.guesserTextField.text = nil})
    }

}
