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
    
    private lazy var postTitle: UILabel = {
        let title = UILabel()
        title.numberOfLines = 2
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.textColor = .black
        
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
        likes.textColor = .black
        
        likes.translatesAutoresizingMaskIntoConstraints = false
        return likes
    }()
    
    private lazy var viewsLabel: UILabel = {
        let views = UILabel()
        views.font = .systemFont(ofSize: 16, weight: .regular)
        views.textColor = .black
        
        views.translatesAutoresizingMaskIntoConstraints = false
        return views
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraints()
        backgroundColor = .white
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
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            postTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
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
        
        likesLabel.text = "Likes: \(String(data.likes))"
        
        viewsLabel.text = "Veiws: \(String(data.views))"
        
    }
    
    func maxY() -> CGFloat {
        likesLabel.frame.maxY 
    }
    
    @objc private func addToFavourites() {
        
        guard let post = self.post else { return }
        
        FavouritePostsService.shared.add(post: post, completion: { [weak self] result in
            
            switch result {
            case .success(_):
                self?.delegate?.presentToast(message: "Added to favourites")
            case .failure(let error):
                if case .alreadyInFavourites = error {
                    self?.delegate?.presentToast(message: "Post is already in favorites")
                }
            }
        })
    }

 }
