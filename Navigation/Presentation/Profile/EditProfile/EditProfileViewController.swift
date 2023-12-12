//
//  EditProfileViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 05.12.2023.
//

import UIKit


final class EditProfileViewController: UIViewController {
    
    // MARK: Private properties
    
    private let viewModel: EditProfileViewModel
    
    // MARK: Subviews
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = Palette.accentOrange
        
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        
        button.addAction(action, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var generalInformationLabel: UILabel = {
       let label = UILabel()
        label.text = "generalInformation".localized
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = Palette.dynamicText
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = Palette.accentOrange
        
        let action = UIAction { [weak self] _ in
            self?.viewModel.updateState(with: .didTapDoneButton(self?.nameTextField.text))
        }
        
        button.addAction(action, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.text = "name".localized
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var nameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "name".localized
        textField.customDelegate = self
        
        
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()
    
    private lazy var mainStack: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(nameTextField)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Init
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Palette.dynamicSecondaryBackground
        
        setupSubviews()
        bindViewModel()
    }
    
    // MARK: Private methods
    
    private func setupSubviews() {
        view.addSubview(dismissButton)
        view.addSubview(generalInformationLabel)
        view.addSubview(doneButton)
        view.addSubview(mainStack)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
        
            dismissButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            dismissButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            dismissButton.heightAnchor.constraint(equalToConstant: 24),
            dismissButton.widthAnchor.constraint(equalToConstant: 24),
            
            generalInformationLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            generalInformationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            doneButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 24),
            doneButton.widthAnchor.constraint(equalToConstant: 24),
            
            mainStack.topAnchor.constraint(equalTo: generalInformationLabel.bottomAnchor, constant: 30),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
    
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            switch state {
            case .initial:
                return 
            case .tryCommitEdit:
                self?.disableButtons()
            case .failedToCommitEdit:
                self?.presentAlert(message: "failedToCommitChanges".localized, feedBackType: .error, addCancelAction: true)
            case .editCommited:
                self?.dismiss(animated: true)
            }
        }
    }

    private func disableButtons(){
        doneButton.isEnabled = false
        dismissButton.isEnabled = false
    }
    
    
}

extension EditProfileViewController: CustomTextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
    }
    
}
