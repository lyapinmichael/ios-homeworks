//
//  SlideOverViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 26.11.2023.
//

import Foundation
import UIKit

protocol SlideOverMenuDelegate: AnyObject {
    
    func slideOverMenu(_ slideOverMenu: SlideOverMenuViewController, didTap logOutButton: UIButton)
    
}

final class SlideOverMenuViewController: UIViewController {
    
    // MARK: Public properties
    
    weak var rootViewController: ProfileRootViewController?
    
    weak var delegate: SlideOverMenuDelegate?
    
    // MARK: Private properties
    
    private let user: User
    
    // MARK: Subviews
    
    private lazy var menuContainer: UIView = {
       let view = UIView()
        view.backgroundColor = Palette.dynamicSecondaryBackground
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.8

        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var hideButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        button.imageView?.tintColor = Palette.accentOrange
        
        let hideAction = UIAction{ [weak self] _ in
            self?.hide()
        }
        
        button.addAction(hideAction, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var displayNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = user.fullName
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("logOut".localized.capitalized, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        button.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.forward"), for: .normal)
        button.imageView?.tintColor = Palette.accentOrange
        
        let buttonAction = UIAction { [weak self] _ in
            guard let self else { return }
            self.delegate?.slideOverMenu(self, didTap: button)
        }
        button.addAction(buttonAction, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var menuVerticalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        
        stackView.addArrangedSubview(displayNameLabel)
        stackView.addArrangedSubview(makeSeparatorLine())
        stackView.addArrangedSubview(logOutButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Init
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        setupSubviews()
       
    }
    
    // MARK: Public methods
    
    func show() {
        view.isHidden = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.view.backgroundColor = Palette.dynamicBackground.withAlphaComponent(0.4)
            self.menuContainer.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    // MARK: Private methods
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupSubviews() {
        view.addSubview(menuContainer)
        menuContainer.addSubview(hideButton)
        menuContainer.addSubview(menuVerticalStack)
         
        
        // Constraints
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            menuContainer.topAnchor.constraint(equalTo: view.topAnchor),
            menuContainer.widthAnchor.constraint(equalToConstant: 308),
            menuContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            hideButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            hideButton.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor, constant: 16),
            hideButton.widthAnchor.constraint(equalToConstant: 24),
            hideButton.heightAnchor.constraint(equalToConstant: 24),
            
            menuVerticalStack.topAnchor.constraint(equalTo: hideButton.bottomAnchor, constant: 24),
            menuVerticalStack.leadingAnchor.constraint(equalTo: menuContainer.leadingAnchor, constant: 16),
            menuVerticalStack.trailingAnchor.constraint(equalTo: menuContainer.trailingAnchor, constant: -16)
        
        ])
        
        // Initial affine transformation
        
        menuContainer.transform = CGAffineTransform(translationX: menuContainer.frame.width, y: 0)
        
    }
    
    private func makeSeparatorLine() -> UIView {
        let lineView = UIView()
        
        lineView.backgroundColor = .systemGray2
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }
    
    // MARK: ObjC methods
    
    @objc func hide() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.view.backgroundColor = Palette.dynamicBackground.withAlphaComponent(0.0)
            self.menuContainer.transform = CGAffineTransform(translationX: self.menuContainer.frame.width, y: 0)
        } completion: { [weak self] _ in
            guard let self else { return }
            self.view.isHidden = true
        }
    }

    
    
}

// MARK: UIGestureRecognizerDelegate

extension SlideOverMenuViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }

    
}
