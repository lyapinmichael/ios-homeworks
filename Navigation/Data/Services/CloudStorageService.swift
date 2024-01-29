//
//  CloudStoreService.swift
//  Navigation
//
//  Created by Ляпин Михаил on 20.10.2023.
//

import Foundation
import FirebaseCore
import FirebaseStorage
import GTMSessionFetcher
import StorageService

// MARK: - CloudStorageService

final class CloudStorageService {
    
    // MARK: Singleton instance
    
    static var shared = CloudStorageService()
    
    // MARK: Private properties
    
    /// Instance to access Cloud Storage
    private let storage = Storage.storage()
    
    
    // MARK: Init
    
    private init() {}
    
    // MARK: Public methods
    
    // MARK: Post image related methods
    
    func uploadImage(_ image: UIImage, forPost postID: String, completionHandler: @escaping (CloudStorageServiceError?) -> Void = { _ in }) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completionHandler(.failedToEncodeJPEGData)
            return
        }
        let reference = storage.reference().child("/postImages/\(postID)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        _ = reference.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error {
                completionHandler(.failedToUploadImage)
                return
            } else {
                completionHandler(nil)
                return
            }
        }
    }
    
    func downloadImage(forPost postID: String, completionHandler: @escaping (Data?, CloudStorageServiceError?) -> Void)  {
        
        let storageReference = storage.reference()
        
        let reference = storageReference.child("/postImages/\(postID)")
        
        reference.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
            
            if let error = error {
                print("\n=====\nError occured while trying to download an image:\n" + "\(error)\n=====\n")
                completionHandler(nil, .userIDisNil)
            }
            
            if let data = data {
                completionHandler(data, nil)
            } else {
                print("Post with ID: \(postID) has no image attached")
                completionHandler(nil, nil)
            }
        }
    }
    
    func deleteImage(forPost post: Post, completionHandler: @escaping (CloudStorageServiceError?) -> Void = { _ in }) {
        guard let postID = post.id else {
            completionHandler(.postIDisNil)
            return
        }
        let reference = storage.reference(withPath: "/postImages/" + postID)
        reference.delete { error in
            if let error {
                print(">>>>>", error)
                completionHandler(.failedToDeleteImage)
                return
            } else {
                completionHandler(nil)
                return
            }
        }
    }
    
    // MARK: Avatar related methods
    
    func downloadAvatar(forUser userID: String, completionHandler: @escaping (Data?, CloudStorageServiceError?) -> Void) {
        let storageReference = storage.reference()
        let reference = storageReference.child("/userAvatars/\(userID)")
        reference.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("\n=====\nError occured while trying to download an image: \n" + "\(error)\n=====\n")
                completionHandler(nil, .userIDisNil)
            }
            
            if let data = data {
                completionHandler(data, nil)
            } else {
                print("User with ID: \(userID) has not uploaded an avatar")
                completionHandler(nil, nil)
            }
        }
    }
    
    func uploadAvatar(_ image: UIImage, forUser userID: String, completionHandler: @escaping (CloudStorageServiceError?) -> Void = { _ in }) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completionHandler(.failedToEncodeJPEGData)
            return
        }
        let metadata = StorageMetadata()
        let reference = storage.reference().child("/userAvatars/\(userID)")
        _ = reference.putData(imageData, metadata: metadata) { metadata, error in
            if let error {
                print(">>>>>\t", error)
                completionHandler(.failedToUploadImage)
            } else {
                FirestoreService().updateUserAvatar(userID, hasAvatar: true)
                completionHandler(nil)
            }
        }
    }
    
    func deleteAvatar(forUser userID: String, completionHandler: @escaping (CloudStorageServiceError?) -> Void = { _ in }) {
        let reference = storage.reference(withPath: "/userAvatars/\(userID)")
        reference.delete { error in
            if error != nil {
                completionHandler(.failedToDeleteImage)
            } else {
                FirestoreService().updateUserAvatar(userID, hasAvatar: false)
                completionHandler(nil)
            }
        }
    }

    
    // MARK: Types
    
    enum CloudStorageServiceError: Error {
        case userIDisNil
        case postIDisNil
        case failedToEncodeJPEGData
        case failedToUploadImage
        case failedToDeleteImage
    }
    
    
}
