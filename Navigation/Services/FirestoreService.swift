//
//  FirestoreService.swift
//  Navigation
//
//  Created by Ляпин Михаил on 16.10.2023.
//

import Foundation
import StorageService
import FirebaseFirestore
import FirebaseFirestoreSwift


final class FirestoreService {
    
    enum FirestoreServiceError: Error {
        // User related errors
        case failedToFetchUserDocument
        case userDocumentDoesntExist
        case failedToDecodeUserDocument
        case failedToCreateNewUserDocument
        
        // Single post related errors
        case failedToFetchPostDocument
        case postDocumentDoesntExist
        case failedToDecodePostDocument
        case failedToCreateNewPostDocument
        
        // All posts related errors
        case filedToFetchPosts
        case badQuerySnapshot
    }
    
    // This property is crucial for further work with firestore.
    // It is received whenever user logs in, so the app knows user identity,
    // and knowing user's identity the app then makes queries into Cloud Firestore
    // to read and write user-specific data, such as posts.
    
    private let dataBase = Firestore.firestore()
    
    private var rootCollectionReference: CollectionReference!
    private var documentReference: DocumentReference!
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    
    // MARK: user data related methods
    
    func fetchUserData(userID: String, completionHandler: @escaping (Result<User, FirestoreServiceError>) -> Void) {
        
        rootCollectionReference = dataBase.collection("users")
        documentReference = rootCollectionReference.document(userID)
        
        documentReference.getDocument { querySnapshot, error in
            
            if let error {
                print(error)
                completionHandler(.failure(.failedToFetchUserDocument))
            }
            
            guard let userDocument = querySnapshot, userDocument.exists  else {
                completionHandler(.failure(.userDocumentDoesntExist))
                return
            }
            
            do {
                let user = try userDocument.data(as: User.self)
                completionHandler(.success(user))
            } catch {
                completionHandler(.failure(.failedToDecodeUserDocument))
            }
        }
    }
    
    func writeUserDocument(_ user: User, completionHandler: @escaping () -> Void) {
        do {
            try dataBase.collection("users").document(user.id).setData(from: user)
            completionHandler()
        } catch {
            print(error)
        }
    }
    
    func updateUserDisplayName(_ updatedUser: User, updatedName: String, completionHandler: @escaping (Error?) -> Void) {
        
        let documentReference = dataBase.collection("users").document(updatedUser.id)
        
        documentReference.updateData([
            "fullName": updatedName
        ]) { error  in
            if let error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    // MARK: Post related methods
        
    func fetchPostData(by userID: String) async throws -> [Post] {
        rootCollectionReference = dataBase.collection("posts")
        do {
            let querySnapshot = try await rootCollectionReference.whereField("authorID", isEqualTo: userID).getDocuments()
            var posts: [Post] = []
            for postDocument in querySnapshot.documents {
                do {
                    let post = try postDocument.data(as: Post.self)
                    posts.append(post)
                } catch {
                    print(">>>>> Failed to parse data from post document:\n\(error)")
                    continue
                }
            }
            return posts
        } catch {
            print(">>>>> Failed to load post document:\n\(error)")
            throw(error)
        }
    }
    
    // TODO: Refactoring needed
    // see db.collection("some").whereField("some", isEqualTo: some).getDocuments
    // in doc
    @available(*, deprecated, message: "Use fetchPostData(by userID: String instead")
    func fetchPostData(_ documentReference: DocumentReference, completionHandler: @escaping (Result<Post, FirestoreServiceError>) -> Void) {
        
        documentReference.getDocument { querySnapshot, error in
            
            if let error {
                print(error)
                completionHandler(.failure(.failedToFetchPostDocument))
            }
            
            guard let postDocument = querySnapshot, postDocument.exists else {
                completionHandler(.failure(.postDocumentDoesntExist))
                return
            }
            
            do {
                let post = try postDocument.data(as: Post.self)
                completionHandler(.success(post))
            } catch {
                print(error)
                completionHandler(.failure(.failedToDecodePostDocument))
            }
        }
    }
    
    func fetchAllPosts(completionHandler: @escaping (Result<[Post], FirestoreServiceError>) -> Void) {
        
        rootCollectionReference = dataBase.collection("posts")
        
        rootCollectionReference.getDocuments { querySnapshot, error in
            
            if let error {
                print(error)
                completionHandler(.failure(.filedToFetchPosts))
            }
            
            guard let querySnapshot else {
                completionHandler(.failure(.badQuerySnapshot))
                return
            }
            
            var posts: [Post] = []
            for document in querySnapshot.documents {
                do {
                    let post = try document.data(as: Post.self)
                    posts.append(post)
                } catch {
                    print("Failed to decode document with id \(document.documentID) as Post object.")
                    continue
                }
            }
            completionHandler(.success(posts))
        }
        
    }
}
