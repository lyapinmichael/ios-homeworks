//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Ляпин Михаил on 02.03.2023.
//

import UIKit
import StorageService

final class PostTableViewCell: UITableViewCell {
    
    static let reuseID = "CustomTableViewCell_ReuseID"
    
    weak var delegate: ProfileViewController?
    
    private var viewModel = PostTableViewCellViewModel()
    
    private var post: Post? {
        didSet {
            if let post,
               let id = post.id,
               post.hasImageAttached {
                postImage.isHidden = false
                postImageHeighAnchorConstraint.constant = 127
                viewModel.getPostImage(postID: id)
            }
        }
    }
    
    // MARK: Subviews
    
    private lazy var authorView: PostAuthorHeaderView = {
        let view = PostAuthorHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var verticalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor =  .systemGray5
        imageView.image = UIImage(named: "ImagePlaceholder")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// A specific height constraint por postImage, that is meant to change in runtime 
    private lazy var postImageHeighAnchorConstraint = NSLayoutConstraint(item: postImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)

    
    private lazy var postText: UILabel = {
        let textLabel = UILabel()
        textLabel.font = .systemFont(ofSize: 14, weight: .regular)
        textLabel.textColor = Palette.dynamicText
        textLabel.sizeToFit()
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    private lazy var revealFull: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = Palette.accentBlue
        label.text = "revealFull".localized + "..."
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var horizontalSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var likesImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")
        imageView.tintColor = Palette.dynamicText
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likesLabel: UILabel = {
        let likes = UILabel()
        likes.font = .systemFont(ofSize: 16, weight: .regular)
        
        likes.translatesAutoresizingMaskIntoConstraints = false
        return likes
    }()
    
    private lazy var viewsLabel: UILabel = {
        let views = UILabel()
        views.font = .systemFont(ofSize: 16, weight: .regular)
        
        views.translatesAutoresizingMaskIntoConstraints = false
        return views
    }()
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraints()
        bindViewModel()
        
        backgroundColor = Palette.dynamicSecondaryBackground
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(addToFavourites))
        doubleTap.numberOfTapsRequired = 2
        self.contentView.addGestureRecognizer(doubleTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // MARK: Public methods
    
    func updateContent(post: Post) {
        self.post = post
        if let postText = post.description {
            self.postText.text = (postText.count > 140) ? (String(postText.prefix(140)) + "...") : postText
            self.revealFull.isHidden = !(postText.count > 140)
        }
        authorView.update(authorDisplayName: post.author, authorID: post.authorID)
        likesLabel.text = String(post.likes)
    }
    
    func maxY() -> CGFloat {
        likesLabel.frame.maxY
    }
    
    
    // MARK: Private methods
    
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            switch state {
            case.initial:
                return
            case .didLoadPostImage(let imageData):
                self?.postImage.image =  UIImage(data: imageData)
            }
        }
    }
    
    private func addSubviews() {
        contentView.addSubview(verticalLine)
        contentView.addSubview(postImage)
        contentView.addSubview(postText)
        contentView.addSubview(revealFull)
        contentView.addSubview(horizontalSeparator)
        contentView.addSubview(likesImage)
        contentView.addSubview(likesLabel)
        contentView.addSubview(viewsLabel)
        contentView.addSubview(authorView)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            authorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            authorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            authorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            verticalLine.topAnchor.constraint(equalTo: authorView.bottomAnchor, constant: 8),
            verticalLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            verticalLine.widthAnchor.constraint(equalToConstant: 1.5),
            verticalLine.bottomAnchor.constraint(equalTo: horizontalSeparator.topAnchor, constant: -8),
            
            postText.topAnchor.constraint(equalTo: authorView.bottomAnchor, constant: 16),
            postText.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor, constant: 12),
            postText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            revealFull.topAnchor.constraint(equalTo: postText.bottomAnchor, constant: 4),
            revealFull.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor, constant: 12),
            revealFull.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            postImage.topAnchor.constraint(equalTo: revealFull.bottomAnchor, constant: 8),
            postImage.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor,constant: 12),
            postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            postImageHeighAnchorConstraint,
            
            horizontalSeparator.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 8),
            horizontalSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalSeparator.heightAnchor.constraint(equalToConstant: 0.8),
            horizontalSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            likesImage.topAnchor.constraint(equalTo: horizontalSeparator.bottomAnchor, constant: 8),
            likesImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likesImage.heightAnchor.constraint(equalToConstant: 20),
            likesImage.widthAnchor.constraint(equalToConstant: 20),
            
            likesLabel.centerYAnchor.constraint(equalTo: likesImage.centerYAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: likesImage.trailingAnchor, constant: 8),
       
            contentView.bottomAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 16)
        ])
        
    }
    
    // MARK: Objc methods
    
    @objc private func addToFavourites() {
        
        guard let post = self.post else { return }
        
        FavouritePostsService.shared.add(post: post, completion: { [weak self] result in
            
            switch result {
            case .success(_):
                
                let addedToFavoritesString = NSLocalizedString("addedToFavorites", comment: "")
                self?.delegate?.presentToast(message: addedToFavoritesString)
                
            case .failure(let error):
                if case .alreadyInFavourites = error {
                    
                    let alreadyInFavoritesString = NSLocalizedString("alreadyInFavorites", comment: "")
                    self?.delegate?.presentToast(message: alreadyInFavoritesString)
                }
            }
        })
    }
    
}
