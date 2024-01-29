//
//  NewPostViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 22.01.2024.
//

import UIKit
import IQKeyboardManagerSwift

final class NewPostViewController: UIViewController {
    
    // MARK: Private properites
    
    private var viewModel: NewPostViewModel
    
    // MARK: Subviews
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("cancel".localized.capitalized, for: .normal)
        button.setTitleColor(Palette.accentOrange, for: .normal)
        let buttonAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        button.addAction(buttonAction, for: .touchUpInside)
        return button
    }()
    
    private lazy var uploadButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = Palette.accentOrange
        configuration.title = "upload".localized.capitalized
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        button.setTitleColor(.white, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.updateState(with: .didTapUploadButton)
        }), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var topButtonsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, uploadButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .bottom
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0,
                                                                     leading: 16,
                                                                     bottom: 0,
                                                                     trailing: 16)
        return stackView
    }()
    
    private lazy var mainTextView: PlaceholderTextView = {
        let textView = PlaceholderTextView(placeholder: "whatsNew".localized.capitalized + "?")
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var attachedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.isUserInteractionEnabled = true
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var detachImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.tintColor = Palette.accentOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        let action = UIAction { [weak self] _ in
            self?.viewModel.updateState(with: .didTapDetachImageButton)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    private lazy var addImageFromRollButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        button.setImage(UIImage(systemName: "photo.fill.on.rectangle.fill"), for: .highlighted)
        button.tintColor = Palette.accentOrange
        let action = UIAction { [weak self] _ in
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self?.present(imagePicker, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    private lazy var addImageFromCameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.setImage(UIImage(systemName: "camera.fill"), for: .highlighted)
        button.tintColor = Palette.accentOrange
        button.isEnabled = false
        return button
    }()
    
    private lazy var bottomButtonsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addImageFromRollButton, addImageFromCameraButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loadingDimmingViewController = LoadingDimmingViewController()
    
    // MARK: Init
    
    init(viewModel: NewPostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(NewPostViewController.self)
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
        mainTextView.becomeFirstResponder()
    }
    
    // MARK: Private methods
    
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self else { return }
            switch state {
            case .initial:
                return
            case .tyringToUpload:
                mainTextView.endEditing(true)
                loadingDimmingViewController.show(on: self)
            case .failedToUpload:
                loadingDimmingViewController.hide()
                self.presentAlert(message: "failedToUpload".localized,
                                  title: "errorOccured".localized,
                                  feedBackType: .error)
            case .didUpload:
                self.dismiss(animated: true)
            case .didChangeImage(let image):
                self.attachedImage.image = image
                self.attachedImage.isHidden = (image == nil)
            }
        }
    }
    
    private func setupSubviews() {
        view.addSubview(topButtonsStack)
        view.addSubview(mainTextView)
        view.addSubview(attachedImage)
        attachedImage.addSubview(detachImageButton)
        view.addSubview(bottomButtonsStack)
        
        let safeArea = view.safeAreaLayoutGuide
        let keyboard = view.keyboardLayoutGuide
        NSLayoutConstraint.activate([
            topButtonsStack.topAnchor.constraint(equalTo: safeArea.topAnchor),
            topButtonsStack.heightAnchor.constraint(equalToConstant: 48),
            topButtonsStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            topButtonsStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            mainTextView.topAnchor.constraint(equalTo: topButtonsStack.bottomAnchor, constant: 24),
            mainTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainTextView.bottomAnchor.constraint(equalTo: attachedImage.topAnchor, constant: 16),
            
            attachedImage.heightAnchor.constraint(equalToConstant: Constants.attachedImageSide),
            attachedImage.widthAnchor.constraint(equalToConstant: Constants.attachedImageSide),
            attachedImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            attachedImage.bottomAnchor.constraint(equalTo: bottomButtonsStack.topAnchor, constant: -16),
            
            detachImageButton.topAnchor.constraint(equalTo: attachedImage.topAnchor, constant: 8),
            detachImageButton.trailingAnchor.constraint(equalTo: attachedImage.trailingAnchor, constant: -8),
            detachImageButton.heightAnchor.constraint(equalToConstant: Constants.detachImageButtonSide),
            detachImageButton.widthAnchor.constraint(equalToConstant: Constants.detachImageButtonSide),
            
            bottomButtonsStack.heightAnchor.constraint(equalToConstant: Constants.bottomButtonsStackHeight),
            bottomButtonsStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            bottomButtonsStack.bottomAnchor.constraint(equalTo: keyboard.topAnchor)
        ])
    }
    
    // MARK: Types
    
    enum Constants {
        static let attachedImageSide: CGFloat = 78
        static let bottomButtonsStackHeight: CGFloat = 40
        static let detachImageButtonSide: CGFloat = 16
    }
    
    
}

// MARK: - UITextViewDelegate

extension NewPostViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        uploadButton.isEnabled = !(textView.text.isEmpty || textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        viewModel.updateState(with: .didChangeText(textView.text))
    }
    
    
}

// MARK: UIImagePickerControllerDelegate

extension NewPostViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        viewModel.updateState(with: .didPickImage(image))
        picker.dismiss(animated: true)
    }
    
}

// MARK: UINavigationControllerDelegate

extension NewPostViewController: UINavigationControllerDelegate {}
