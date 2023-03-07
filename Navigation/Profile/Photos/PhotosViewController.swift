//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 06.03.2023.
//

import UIKit

// MARK: - PhotosViewController class

final class PhotosViewController: UIViewController {
    
    // MARK: - Private properties
    
    fileprivate let photos = Photo.make()
    
    private enum Constants {
        static let spacing: CGFloat = 8
        static let itemsInRow: CGFloat = 3
        static let edgeInsets = UIEdgeInsets(
            top: 8,
            left: 8,
            bottom: 8,
            right: 8
        )
    }
    
    private enum CellReuseID: String {
        case basePhotoCell = "BasePhotoCell_ID"
    }
    
    private lazy var photosCollection: UICollectionView = {
        let photosLayout = UICollectionViewFlowLayout()
        
        let photosCollection = UICollectionView(frame: .zero, collectionViewLayout: photosLayout)
        
        photosCollection.register(
            PhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: CellReuseID.basePhotoCell.rawValue)
        
        photosCollection.translatesAutoresizingMaskIntoConstraints = false
        
        return photosCollection
    }()
    
    // MARK: - Lyfecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPhotosCollection()
        addSubviews()
        setConstraints()
    
    }
    
    
    // MARK: - Private methods
    private func setupPhotosCollection() {
        photosCollection.dataSource = self
        photosCollection.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(photosCollection)
    }
    
    private func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            photosCollection.topAnchor.constraint(equalTo: safeArea.topAnchor),
            photosCollection.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            photosCollection.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            photosCollection.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
}

// MARK: - DataSource extension

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuseID.basePhotoCell.rawValue, for: indexPath) as! PhotosCollectionViewCell
        cell.updateContent(with: photos[indexPath.row])
        return cell
    } 

}

// MARK: - ViewDelegateFlowLayout extension

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    private func itemWidth(for width: CGFloat) -> CGFloat {
        
        let totalSpacing: CGFloat = 2 * Constants.spacing + (Constants.itemsInRow - 1) * Constants.spacing
        let finalWidth = (width - totalSpacing) / Constants.itemsInRow
        
        return floor(finalWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemWidth(for: view.frame.width)
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        Constants.edgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.spacing
    }
    
}
