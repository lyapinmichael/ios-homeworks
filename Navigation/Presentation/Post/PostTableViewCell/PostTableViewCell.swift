//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Ляпин Михаил on 02.03.2023.
//

import UIKit
import StorageService

protocol PostTableViewCellDelegate: AnyObject {
    func postTableViewCell(_ postTableViewCell: PostTableViewCell, didTapButton button: UIButton, actionsFor post: Post)
    func postTableViewCell(_ postTableViewCell: PostTableViewCell, askToPresentToastWithMessage message: String)
}

extension PostTableViewCellDelegate {
    func postTableViewCell(_ postTableViewCell: PostTableViewCell, askToDeletePost: Post) {}
    func postTableViewCell(_ postTableViewCell: PostTableViewCell, askToPresentToastWithMessage message: String) {}
}

// MARK: -  PostTableViewCell

final class PostTableViewCell: UITableViewCell {
    
    static let reuseID = "CustomTableViewCell_ReuseID"
    
    // MARK: Public properties
    
    weak var delegate: PostTableViewCellDelegate?
    
    private(set) var image: UIImage? {
        didSet {
            postImageView.image =  image
        }
    }

    var post: Post? {
        get {
            return viewModel.post
        }
    }
    
    var isActionsButtonHidden = false {
        didSet {
            authorView.isActionsButtonsHidden = isActionsButtonHidden
        }
    }
    
    // MARK: Private properties
    
    private var viewModel = PostTableViewCellViewModel()
    
    // MARK: Subviews
    
    private lazy var authorView: PostAuthorHeaderView = {
        let view = PostAuthorHeaderView()
        view.isActionsButtonsHidden = self.isActionsButtonHidden
        view.delegate = self
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
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor =  .systemGray5
        imageView.image = UIImage(named: "ImagePlaceholder")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// A specific height constraint for postImage, that is meant to change in runtime 
    private lazy var postImageHeighAnchorConstraint = NSLayoutConstraint(item: postImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)

    
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
    
    private lazy var savePostButton: UIButton = {
       let button = WideTapAreaButton()
        let image = viewModel.isPostSaved ? ButtonImages.bookmarkFill : ButtonImages.bookmark
        button.setImage(image, for: .normal)
        button.tintColor = Palette.accentOrange
        let action = UIAction { [weak self] _ in
            self?.viewModel.updateState(with: .didTapSavePostButton)
        }
        button.addAction(action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraints()
        bindViewModel()
        
        backgroundColor = Palette.dynamicSecondaryBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = UIImage(named: "ImagePlaceholder")
        postImageView.isHidden = true
        postImageHeighAnchorConstraint.constant = 1
        let image = viewModel.isPostSaved ? ButtonImages.bookmarkFill : ButtonImages.bookmark
        savePostButton.setImage(image, for: .normal)
    }
    
    // MARK: Public methods
    
    func updateContent(post: Post, authorDisplayName: String? = nil, authorAvatar: UIImage? = nil) {
        self.viewModel.updateState(with: .didReceivePost(post))
        if let postText = post.description {
            self.postText.text = (postText.count > 140) ? (String(postText.prefix(140)) + "...") : postText
            self.revealFull.isHidden = !(postText.count > 140)
        }
        authorView.update(authorDisplayName: authorDisplayName ?? post.author,
                          authorID: post.authorID,
                          authorAvatar: authorAvatar)
        likesLabel.text = String(post.likes)
    }
    
    func maxY() -> CGFloat {
        likesLabel.frame.maxY
    }
    
    func passRepository(_ repository: ProfileRepository) {
        viewModel.repository = repository
    }
    
    // MARK: Private methods
    
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self else { return }
            switch state {
            case .initial:
                return
            case .prepareImageView:
                self.postImageView.isHidden = false
                self.postImageHeighAnchorConstraint.constant = 127
            case .didLoadPostImage(let imageData):
                self.image = UIImage(data: imageData)
                self.setNeedsLayout()
            case .didLoadAvatar(let image):
                self.authorView.update(authorAvatar: image)
            case .postSavedSuccessfully:
                self.savePostButton.setImage(ButtonImages.bookmarkFill, for: .normal)
                self.delegate?.postTableViewCell(self, askToPresentToastWithMessage: "addedToFavorites".localized)
            case .failedToSavePost:
                self.delegate?.postTableViewCell(self, askToPresentToastWithMessage: "alreadyInFavorites".localized)
            case .didCheckIsPostSaved:
                let image = self.viewModel.isPostSaved ? ButtonImages.bookmarkFill : ButtonImages.bookmark
                self.savePostButton.setImage(image, for: .normal)
            }
        }
    }
    
    private func addSubviews() {
        contentView.addSubview(verticalLine)
        contentView.addSubview(postImageView)
        contentView.addSubview(postText)
        contentView.addSubview(revealFull)
        contentView.addSubview(horizontalSeparator)
        contentView.addSubview(likesImage)
        contentView.addSubview(likesLabel)
        contentView.addSubview(viewsLabel)
        contentView.addSubview(authorView)
        contentView.addSubview(savePostButton)
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
            
            postImageView.topAnchor.constraint(equalTo: revealFull.bottomAnchor, constant: 8),
            postImageView.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor,constant: 12),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            postImageHeighAnchorConstraint,
            
            horizontalSeparator.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 8),
            horizontalSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalSeparator.heightAnchor.constraint(equalToConstant: 0.8),
            horizontalSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            likesImage.topAnchor.constraint(equalTo: horizontalSeparator.bottomAnchor, constant: 8),
            likesImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likesImage.heightAnchor.constraint(equalToConstant: 20),
            likesImage.widthAnchor.constraint(equalToConstant: 20),
            
            likesLabel.centerYAnchor.constraint(equalTo: likesImage.centerYAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: likesImage.trailingAnchor, constant: 8),
            
            savePostButton.centerYAnchor.constraint(equalTo: likesImage.centerYAnchor),
            savePostButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            savePostButton.heightAnchor.constraint(equalToConstant: 20),
            savePostButton.widthAnchor.constraint(equalToConstant: 20),

            contentView.bottomAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 16)
        ])
        
    }
    
    // MARK: Types
    
    enum ButtonImages {
        static let bookmark = UIImage(systemName: "bookmark")
        static let bookmarkFill = UIImage(systemName: "bookmark.fill")
    }
    
}

// MARK: PostAuthorHeaderViewDelegate

extension PostTableViewCell: PostAuthorHeaderViewDelegate {
    
    func postAuthorHeaderView(_ postAuthorHeaderView: PostAuthorHeaderView, didTapThreeDotsButton button: UIButton) {
        guard let post = viewModel.post else { return }
        delegate?.postTableViewCell(self, didTapButton: button, actionsFor: post)
    }
    
}
