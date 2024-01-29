//
//  ProfileAvatarDimmingViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 26.01.2024.
//

import UIKit

final class ImageDimmingViewController: DimmingViewController {
    
    // MARK: Private properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var closeImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.tintColor = Palette.accentOrange
        let action = UIAction { [weak self] _ in
            self?.hide()
        }
        button.addAction(action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Init
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.addSubview(imageView)
        view.addSubview(closeImageButton)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            closeImageButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 24),
            closeImageButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            closeImageButton.heightAnchor.constraint(equalToConstant: 38),
            closeImageButton.widthAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    
}
