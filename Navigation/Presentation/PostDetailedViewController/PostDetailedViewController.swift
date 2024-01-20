//
//  PostDetailedViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 08.01.2024.
//

import UIKit
import StorageService

final class PostDetailedViewController: UIViewController {
    
    // MARK: Subviews
    
    private lazy var containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = Palette.dynamicBackground
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var authorAvatar: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: .zero, y: .zero, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Palette.dynamicTextfield
        imageView.layer.cornerRadius = imageView.bounds.height / 2
        imageView.layer.borderWidth = 0.8
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "ImagePlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var authorName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = Palette.accentOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "ImagePlaceholder")
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var postText: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = Palette.dynamicText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = Palette.dynamicText
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var likesCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = Palette.dynamicText
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Init
    
    init(post: Post) {
        super.init(nibName: nil, bundle: nil)
        postText.text = post.description
        authorName.text = post.author
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackIndicatorImage")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackIndicatorImage")
        setupSubviews()
    }
    
    // MARK: Private methods

    private func setupSubviews() {
        view.addSubview(containerScrollView)
        containerScrollView.addSubview(contentView)
        contentView.addSubview(authorAvatar)
        contentView.addSubview(authorName)
        contentView.addSubview(postImage)
        contentView.addSubview(postText)
        contentView.addSubview(likeButton)
        contentView.addSubview(likesCountLabel)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            containerScrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            containerScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor ),
            contentView.trailingAnchor.constraint(equalTo: containerScrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            
            authorAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            authorAvatar.widthAnchor.constraint(equalToConstant: 30),
            authorAvatar.heightAnchor.constraint(equalToConstant: 30),
            authorAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            authorName.centerYAnchor.constraint(equalTo: authorAvatar.centerYAnchor),
            authorName.leadingAnchor.constraint(equalTo: authorAvatar.trailingAnchor, constant: 16),
            
            postImage.topAnchor.constraint(equalTo: authorAvatar.bottomAnchor, constant: 12),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            postImage.heightAnchor.constraint(equalToConstant: contentView.frame.width / 1.773),
            
            postText.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 16),
            postText.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            postText.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),
            
            likeButton.topAnchor.constraint(equalTo: postText.bottomAnchor, constant: 16),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            
            likesCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likesCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 10),
            
            contentView.bottomAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 16),
            containerScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
}
