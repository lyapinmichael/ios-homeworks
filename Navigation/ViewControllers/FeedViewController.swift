//
//  FeedViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 10.02.2023.
//

import UIKit
import StorageService

final class FeedViewController: UIViewController {

    // MARK: - Private properties
    private let postsArray = Post.make()
    private let feedModel = FeedModel()
    
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
        button.setTitle("Open Post", for: .normal)

        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var guesserTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "correct word: discombobulate"
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
            self?.feedModel.check(text)
            
        }
        
        let button = CustomButton(title: "Check!", color: UIColor(named: "ColorSet"), action: buttonAction)
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }()
    
    private lazy var checkResultLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nothing was checked yet"
        label.textColor = .gray
        
        return label
    }()
    
    // MARK: - Private methods

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
        let message = "Enter something so it can be checked "
        
        let alert = UIAlertController(title: "Ooops",
                                      message: message,
                                      preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Close",
                                          style: .cancel)
        
        alert.addAction(dismissAction)
        
        self.present(alert,
                     animated: true,
                     completion: {self.guesserTextField.text = nil})
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Feed"
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        setupStackView()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didCheckGuess(_:)),
                                               name: FeedModelNotification.checkResult,
                                               object: nil)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - ObjcMethods
    
    @objc func buttonPressed (_ sender: UIButton) {
        
        let post = postsArray[0]
        let postViewController = PostViewController()
        postViewController.title = post.title
        navigationController?.pushViewController(postViewController, animated: true)
    
    }
    
    @objc func dismissKeyboard () {
        guesserTextField.endEditing(true)
        
    }
    
    // MARK: Check button action
    @objc func didCheckGuess(_ notification: NSNotification) {
        let message: String
        
        guard let isChecked = notification.userInfo?["isChecked"] as? Bool else { return }
        
        switch isChecked {
        case true:
            message = "Congrats! You're right!"
            checkResultLabel.text = "Right"
            checkResultLabel.textColor = .green
        case false:
            message = "You're wrong! Try again!"
            checkResultLabel.text = "Wrong"
            checkResultLabel.textColor = .red
        }
        
        let alert = UIAlertController(title: "Guess was checked and...",
                                      message: message,
                                      preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Close",
                                          style: .cancel)
        
        alert.addAction(dismissAction)
        
        self.present(alert,
                     animated: true,
                     completion: {self.guesserTextField.text = nil})
    }

}
