//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Ляпин Михаил on 02.03.2023.
//

import UIKit
import StorageService

final class PostTableViewCell: UITableViewCell {
    
    weak var delegate: ProfileViewController?
    
    private var post: Post?
    
    private lazy var authorTitle: UILabel = {
       let title = UILabel()
        title.numberOfLines = 1
        title.font = .systemFont(ofSize: 16, weight: .semibold)
        title.textColor = .darkGray
        
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var postTitle: UILabel = {
        let title = UILabel()
        title.numberOfLines = 2
        title.font = .systemFont(ofSize: 20, weight: .bold)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var postText: UILabel = {
        let textLabel = UILabel()
        textLabel.font = .systemFont(ofSize: 14, weight: .regular)
        textLabel.textColor = .systemGray
        textLabel.sizeToFit()
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraints()
        backgroundColor = Palette.dynamicBars
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(addToFavourites))
        doubleTap.numberOfTapsRequired = 2
        self.contentView.addGestureRecognizer(doubleTap)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func addSubviews() {
        contentView.addSubview(postTitle)
        contentView.addSubview(postImage)
        contentView.addSubview(postText)
        contentView.addSubview(likesLabel)
        contentView.addSubview(viewsLabel)
        contentView.addSubview(authorTitle)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            authorTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            authorTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            postTitle.topAnchor.constraint(equalTo: authorTitle.bottomAnchor, constant: 8),
            postTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            postImage.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 16),
            postImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            postImage.heightAnchor.constraint(equalTo: postImage.widthAnchor),
            
            postText.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 16),
            postText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            likesLabel.topAnchor.constraint(equalTo: postText.bottomAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            viewsLabel.topAnchor.constraint(equalTo: postText.bottomAnchor),
            viewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            contentView.bottomAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 16)
        ])
    }
    
    func updateContent(_ data: Post) {
        
        self.post = data
        
        authorTitle.text = data.author
        postTitle.text = data.title
        
        if let postImage = data.image {
            self.postImage.image = UIImage(named: postImage)
        } else {
            self.postImage.image = UIImage(named: "ImagePlaceholder")
            self.postImage.backgroundColor = .systemGray5
        }
        
        if let postText = data.description {
            self.postText.text = postText
        }
        
        likesLabel.text = NSLocalizedString("likes", comment: "") + "\(String(data.likes))"
        
        viewsLabel.text = NSLocalizedString("views", comment: "") + "\(String(data.views))"
        
    }
    
    func maxY() -> CGFloat {
        likesLabel.frame.maxY 
    }
    
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
