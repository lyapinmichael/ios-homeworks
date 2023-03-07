//
//  ProfilePhotosCell.swift
//  Navigation
//
//  Created by Ляпин Михаил on 05.03.2023.
//

import UIKit

final class ProfilePhotosCell: UICollectionViewCell {
    
    static let id = "ProfilePhotosCell"
    
    private lazy var photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        
        photoView.translatesAutoresizingMaskIntoConstraints = false
        return photoView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 6
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(photoView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            photoView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            photoView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            photoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
     func updateContent(with photo: Photo) {
            photoView.image = UIImage(named: photo.name)
    }
    
    func updateContent(with placeholder: String) {
        photoView.image = UIImage(named: placeholder)
        photoView.backgroundColor = .systemGray5
        photoView.contentMode = .scaleAspectFit
    }
}
