//
//  PostAuthorHeader.swift
//  Navigation
//
//  Created by Ляпин Михаил on 07.01.2024.
//

import UIKit

final class PostAuthorHeaderView: UIView {
    
    // MARK: Private properties
    
    private let viewModel = PostAuthorHeaderViewModel()
    private var authorID: String? {
        didSet {
            if let authorID {
                viewModel.updateState(with: .requestAvatar(authorID: authorID))
            }
        }
    }
    
    // MARK: Subviews
    
    private lazy var authorAvatar: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: .zero, y: .zero, width: 60, height: 60))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Palette.dynamicTextfield
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.layer.borderWidth = 0.8
        imageView.layer.masksToBounds = true
        imageView.image =  UIImage(named: "ImagePlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var threeDotsButton: UIButton = {
      let button = UIButton()
        button.setImage(UIImage(named: "ThreeDotsVertical"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        backgroundColor = Palette.dynamicBars
        setupSubviews()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods
    
    func update(authorDisplayName: String, authorID: String? = nil) {
        authorNameLabel.text = authorDisplayName
        self.authorID = authorID
    }
    
    // MARK: Private methods
    
    private func setupSubviews() {
        addSubview(authorAvatar)
        addSubview(authorNameLabel)
        addSubview(threeDotsButton)
        
        NSLayoutConstraint.activate([
            authorAvatar.centerYAnchor.constraint(equalTo: centerYAnchor),
            authorAvatar.widthAnchor.constraint(equalToConstant: 60),
            authorAvatar.heightAnchor.constraint(equalToConstant: 60),
            authorAvatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            authorNameLabel.centerYAnchor.constraint(equalTo: authorAvatar.centerYAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: authorAvatar.trailingAnchor, constant: 24),
            authorNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: threeDotsButton.leadingAnchor, constant: -8),
            
            threeDotsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            threeDotsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            threeDotsButton.heightAnchor.constraint(equalToConstant: 21),
            
            heightAnchor.constraint(equalTo: authorAvatar.heightAnchor, constant: 24)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            switch state {
            case .initial:
                return
            case .didReceiveAuthorsAvatar(let image):
                self?.authorAvatar.image = image
            }
        }
    }
    
    
}
