//
//  DeletePostViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 24.01.2024.
//

import UIKit
import StorageService

protocol PostActionsViewControllerDelegate: AnyObject {
    func postActionsViewController(_ postActionsViewController: PostActionsViewController, didTapDeleteButton button: UIButton, forPost post: Post)
    func postActionsViewController(_ postActionsViewController: PostActionsViewController, didTapShareButton button: UIButton, forPost post: Post)
}

// MARK: - PostActionsViewController

final class PostActionsViewController: UIViewController {
    
    // MARK: Public properties
    
    weak var delegate: PostActionsViewControllerDelegate?
    
    // MARK: Private properties
    
    private let post: Post
    
    // MARK: Subviews
    
    private lazy var mainStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [shareButton,
                                                       deleteButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.backgroundColor = Palette.dynamicSecondaryBackground
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("share".localized, for: .normal)
        button.setTitleColor(Palette.dynamicText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return button
    }()
    
    private lazy var archivateButton: UIButton = {
        let button = UIButton()
        button.setTitle("archivate".localized, for: .normal)
        button.setTitleColor(Palette.dynamicText, for: .normal)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("delete".localized, for: .normal)
        button.setTitleColor(Palette.dynamicText, for: .normal)
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            self.delegate?.postActionsViewController(self, didTapDeleteButton: button, forPost: self.post)
        }
        button.addAction(action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return button
    }()
    
    // MARK: Init
    
    init(actionsFor post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    // MARK: Private methods
    
    private func setupSubviews() {
        view.addSubview(mainStack)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
            view.widthAnchor.constraint(equalToConstant: 300),
            view.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 5)
        ])
    }
    
    
}
