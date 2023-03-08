//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Ляпин Михаил on 04.03.2023.
//

import UIKit

// MARK: - class PhotosTableViewCell

final class PhotosTableViewCell: UITableViewCell {

    // MARK: - Private properties
    
    fileprivate let photos = Photo.make()
    
    private enum Constants {
        static let spacing: CGFloat = 8
        static let offset: CGFloat = 12
        static let itemsInRow: CGFloat = 4
    }
    
    private lazy var photosLabel: UILabel = {
        let label = UILabel()
        label.text = "Photos"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var arrowImage: UIImageView = {
        let arrow = UIImageView()
        arrow.image = UIImage(systemName: "arrow.forward")
        arrow.tintColor = .black
        arrow.clipsToBounds = true
        arrow.translatesAutoresizingMaskIntoConstraints = false
        return arrow
    }()
    
    private lazy var photosCollection: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
    
        let photosCollection = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        photosCollection.register(
            PhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotosCollectionViewCell.id)
        
        photosCollection.translatesAutoresizingMaskIntoConstraints = false
        return photosCollection
    }()
    
    // MARK: - Override
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .none
        accessoryView = nil
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        contentView.addSubview(photosLabel)
        contentView.addSubview(photosCollection)
        contentView.addSubview(arrowImage)
        
        photosCollection.dataSource = self
        photosCollection.delegate  = self
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            photosLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.offset),
            photosLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.offset),
            
            arrowImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.offset),
            arrowImage.centerYAnchor.constraint(equalTo: photosLabel.centerYAnchor),
            
            photosCollection.topAnchor.constraint(equalTo: photosLabel.bottomAnchor, constant: Constants.offset),
            photosCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.offset),
            photosCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.offset),
            photosCollection.heightAnchor.constraint(equalToConstant: itemWidth(for: contentView.frame.width)),
            
            contentView.bottomAnchor.constraint(equalTo: photosCollection.bottomAnchor, constant: Constants.offset)
            
        ])

        
    }
    
    // MARK: - Public methods
    
    func setup(_ frame: CGRect) {
        contentView.frame = frame
        addSubviews()
        setConstraints()
    
    }
}

// MARK: - DataSource extension

extension PhotosTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Int(Constants.itemsInRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.id, for: indexPath) as! PhotosCollectionViewCell
        
        if photos.indices.contains(indexPath.row) {
            cell.updateContent(with: photos[indexPath.row])
        } else {
            cell.updateContent(with: "ImagePlaceholder" )
        }
        
        cell.contentView.layer.cornerRadius = 6
        return cell
    }
}

// MARK: - DelegateFlowLayout extension

extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    
    private func itemWidth(for width: CGFloat) -> CGFloat {
        
        let totalSpacing: CGFloat = 2 * Constants.offset + (Constants.itemsInRow - 1) * Constants.spacing
        let finalWidth = (width - totalSpacing) / Constants.itemsInRow
        
        return (finalWidth)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemWidth(for: contentView.frame.width)
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.spacing
    }
}


