//
//  PostTableViewCellViewModel.swift
//  Navigation
//
//  Created by Ляпин Михаил on 12.11.2023.
//

import Foundation
import UIKit.UIImage
import StorageService

// MARK: - PostTableViewCellViewModel

final class PostTableViewCellViewModel {
    
    // MARK: State related public properies
    
    var onStateDidChange: ((State) -> Void)?
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
        
    // MARK: Public properties
    
    var repository: ProfileRepository?
    
    private(set) var isPostSaved: Bool = false
    private(set) var post: Post? {
        didSet {
            if let post,
               let id = post.id,
               post.hasImageAttached {
                state = .prepareImageView
                getPostImage(postID: id)
            }
        }
    }
    
    // MARK: Private properties
    
    private let timeInteval: DispatchTime = .now() + 0.5
    private let maxAttempts: Int = 3
    private var attemptsMade: Int = 0
        
    // MARK: Public  methods
    
    func updateState(with viewInput: ViewInput) {
        switch viewInput {
        case .didTapSavePostButton:
            onSaveButtonDidTap()
        case .didReceivePost(let post):
            self.post = post
            checkIfPostIsSaved()
        }
    }
    
    func getPostImage(postID: String){
        if let repository,
           let imageData = repository.imageCache.object(forKey: NSString(string: postID)) as? Data {
            state = .didLoadPostImage(imageData)
        } else {
            do {
                let imageData = try LocalStorageService.default.readPostImageCache(from: postID)
                state = .didLoadPostImage(imageData)
            } catch {
                print(error)
                if error as? LocalStorageService.CacheServiceError == .fileDoesntExists {
                 downloadImage(postID)
                }
            }
        }
    }
    
    func fetchAvatar(userID: String) {
        if let repository,
           let imageNSData = repository.imageCache.object(forKey: NSString(string:  userID)),
           let image = UIImage(data: Data(referencing: imageNSData)) {
            state = .didLoadAvatar(image)
        } else {
            do {
                let imageData = try LocalStorageService.default.readUserAvatarCache(from: userID)
                if let image = UIImage(data: imageData) {
                    state = .didLoadAvatar(image)
                }
                repository?.imageCache.setObject(NSData(data: imageData),
                                                 forKey: NSString(string: userID))
            } catch {
                CloudStorageService.shared.downloadAvatar(forUser: userID) { [weak self] imageData, error in
                    guard let self else { return }
                    if let error {
                        return
                    }
                    if let  imageData,
                       let image = UIImage(data: imageData),
                       let imageData = image.jpegData(compressionQuality: 0.8) {
                        try? LocalStorageService.default.writeUserAvatarCache(userID: userID,
                                                                              jpegData: imageData)
                        self.repository?.imageCache.setObject(NSData(data: imageData),
                                                              forKey: NSString(string: userID))
                        self.state = .didLoadAvatar(image)
                    }
                }
            }
        }
    }
    
    // MARK: Private methods
    
    private func downloadImage(_ postID: String) {
        CloudStorageService.shared.downloadImage(forPost: postID) { [weak self] imageData, error in
            guard let self else { return }
            
            if let error {
                print(error)
                guard attemptsMade < maxAttempts else {
                    print(">>>>> Too many attemts. Returning")
                    return
                }
                attemptsMade += 1
                DispatchQueue.main.asyncAfter(deadline: timeInteval) {
                    self.downloadImage(postID)
                }
                return
            } else if let imageData {
                repository?.imageCache.setObject(NSData(data: imageData), forKey: NSString(string: postID))
                state = .didLoadPostImage(imageData)
                do {
                    try LocalStorageService.default.writePostImageCache(from: (postID, imageData))
                } catch {
                    print("=====\nError occured while trying to save image to file:\n\(error)\n=====")
                }
            }
        }
    }
    
    private func onSaveButtonDidTap() {
        guard let post else { return }
        if isPostSaved {
            FavouritePostsService.shared.delete(post)
            isPostSaved = false
            state = .didCheckIsPostSaved
        } else {
            FavouritePostsService.shared.add(post: post) { [weak self] result in
                switch result {
                case .success:
                    self?.isPostSaved = true
                    self?.state = .postSavedSuccessfully
                case .failure(let error):
                    self?.isPostSaved = false
                    print(">>>>>\t", error)
                    self?.state = .failedToSavePost
                }
            }
        }
    }
    
    private func checkIfPostIsSaved() {
        guard let post else { return }
        FavouritePostsService.shared.checkIsPostSaved(post) { [weak self] flag in
            self?.isPostSaved = flag
            self?.state = .didCheckIsPostSaved
        }
    }
    
    // MARK: Types
    
    typealias ImageData = Data
    
    enum State {
        case initial
        case didLoadPostImage(ImageData)
        case didLoadAvatar(UIImage)
        case prepareImageView
        case postSavedSuccessfully
        case failedToSavePost
        case didCheckIsPostSaved
    }
    
    enum ViewInput {
        case didTapSavePostButton
        case didReceivePost(Post)
    }
    
    
}
