//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 06.03.2023.
//

import UIKit
import iOSIntPackage

// MARK: - PhotosViewController class

final class PhotosViewController: UIViewController {
    
    // MARK: - Public properties
    
    let imageProcessor = ImageProcessor()
    
    // MARK: - Private properties
    
    private var photos = Photo.shared.testPhotos
    
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
    
    private lazy var processBarButton: UIBarButtonItem = {
       let processBarButton = UIBarButtonItem(image: UIImage(systemName: "bolt.horizontal.fill"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(barButtonPressed))
        return processBarButton
    }()
    
    // MARK: - Lyfecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = processBarButton
        
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
    
    private func filterImagesOnThreadMeasuringTime() {
        imageProcessor.processImagesOnThread(sourceImages: photos,
                                             filter: .colorInvert,
                                             qos: .utility,
                                             completion: {images in
            print("Completion closure running in thread \(Thread.current)")
            
            DispatchQueue.main.async {
                print ("Now returning to thread \(Thread.current)")
                self.photos = images.map {
                    guard let cgImage = $0 else {fatalError("something went wrong while getting images")}
                    return UIImage(cgImage: cgImage)
                }
                self.photosCollection.reloadSections(IndexSet(integer: 0))
            }
        })
    }
    
    // MARK: - Objc methods
    
    @objc private func barButtonPressed() {
        let clock = ContinuousClock()
        let result = clock.measure(filterImagesOnThreadMeasuringTime)
        
        print(result)
        
        /// Elapsed time depending on QoS:
        ///
        /// with QoS .userInteractive elapsed time equals 0.000414542 seconds
        /// with QoS .utility elapsed time equals 0.000516208 seconds
        /// with QoS .userInitiated elapsed time equals 0.00073225 seconds
        /// with QoS .default elapsed time equals 0.000742334 seconds
        /// with QoS .background elapsed time equals 0.001048792 seconds
    }
    
}

// MARK: - DataSource extension

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return photos.count
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
