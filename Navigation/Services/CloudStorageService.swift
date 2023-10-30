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

final class CloudStorageService {
    
    enum CloudStorageServiceError: Error {
        case userIDisNil
    }
    
    private let storage = Storage.storage()
    
    var userID: String?
    
    // TODO: Needs refactoring! Non functional yet!
    func uploadImage(forPost postID: String) {
        
//        guard let imageURL = post.imageURL,
//              let image = UIImage(named: imageURL) else {
//            print("Bad image URL")
//            return
//        }
//        
//        guard let imageData = image.jpegData(compressionQuality: 1) else {
//            print("Failed to convert UIImage into JPEG data")
//            return
//        }
//        
//        let reference = storage.reference().child("/postImages/\(user.id)/\(postID)")
//        
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//        
//        _ = reference.putData(imageData, metadata: metadata) { (metadata, error) in
//            
//            if let error {
//                print("Error occured while trying to upload post image: \n\n" + "\(error)")
//                return
//            }
//            
//            print("Successfully uploaded post image to storage")
//            
//        }
        
    }
    
    func downloadImage(forPost postID: String, completionHandler: @escaping (Data?, CloudStorageServiceError?) -> Void)  {
        
        guard let userID = userID else {
            print("User id cannot be nil. Pass valid user id")
            completionHandler(nil, .userIDisNil)
            return
        }
        
        let storageReference = storage.reference()
        
        let reference = storageReference.child("/postImages/\(userID)/\(postID)")
        
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
    
}
