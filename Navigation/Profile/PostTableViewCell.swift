//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Ляпин Михаил on 02.03.2023.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
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
    
    private lazy var postText: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.textColor = .systemGray
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
        
        postTitle.text = data.title
        
        if let postImage = data.image {
            self.postImage.image = UIImage(named: postImage)
            self.postImage.heightAnchor.constraint(equalTo: self.postImage.widthAnchor).isActive = true
        }
        
        if let postText = data.description {
            self.postText.text = postText
        }
        
        likesLabel.text = String(data.likes)
        
        viewsLabel.text = String(data.views)
        
    }
    
    func maxY() -> CGFloat {
        likesLabel.frame.maxY 
    }
    

}
