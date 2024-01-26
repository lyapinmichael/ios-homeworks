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
import FirebaseAuth


final class FirestoreService {
    
    enum FirestoreServiceError: Error {
        // User related errors
        case failedToFetchUserDocument
        case userDocumentDoesntExist
        case failedToDecodeUserDocument
        case failedToCreateNewUserDocument
        case failedToUpdateUserDisplayName
        case updatedUserIsNotCurrentUser
        
        // Single post related errors
        case failedToFetchPostDocument
        case postDocumentDoesntExist
        case postIDNil
        case failedToDecodePostDocument
        case failedToCreateNewPostDocument
        case failedToEncodePostData
        case failedToDeletePostDocument
        
        
        // All posts related errors
        case failedToFetchPosts
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

    func writeUserDocument(_ user: User, completionHandler: @escaping (Error?) -> Void) {
        do {
            try dataBase.collection("users").document(user.id).setData(from: user)
            completionHandler(nil)
        } catch {
            print(error)
            completionHandler(error)
        }
    }
    
    func updateUserDisplayName(_ updatedUser: User, updatedName: String, completionHandler: @escaping (Error?) -> Void) {
        
        /// First, change display name in Auth credentials
        guard let authUser = Auth.auth().currentUser,
              authUser.uid == updatedUser.id else {
            completionHandler(FirestoreServiceError.updatedUserIsNotCurrentUser)
            return
        }
        let changeRequest = authUser.createProfileChangeRequest()
        changeRequest.displayName = updatedName
        
        
        changeRequest.commitChanges() { error in
            if  let error {
                completionHandler(FirestoreServiceError.failedToUpdateUserDisplayName)
                return
            }
        }
        
        /// Then, change full name in corresponding firestore document
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
        
        /// Finally, change auhtor's name in all posts
        dataBase.collection("posts").whereField("authorID", isEqualTo: updatedUser.id).getDocuments { [weak self] querySnapshot, error in
            if let error {
                print(">>>>>\t", error)
                return
            }
            guard let batch = self?.dataBase.batch(),
                  let querySnapshot else {
                return
            }
            for document in querySnapshot.documents {
                batch.updateData(["author": updatedName], forDocument: document.reference)
            }
            batch.commit()
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
                completionHandler(.failure(.failedToFetchPosts))
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
    
    func writeNewPost(_  post: inout Post, completionHandler: @escaping (Result<Post, FirestoreServiceError>) -> Void) {
        rootCollectionReference = dataBase.collection("posts")
        do {
            let postDocumentReference = try rootCollectionReference.addDocument(from: post)
            post.id = postDocumentReference.documentID
            completionHandler(.success(post))
        } catch {
            completionHandler(.failure(.failedToEncodePostData))
        }
    }
    
    func deletePost(_ post: Post, completionHandler: @escaping (FirestoreServiceError?) -> Void) {
        rootCollectionReference = dataBase.collection("posts")
        guard let postID = post.id else {
            completionHandler(.postIDNil)
            return
        }
        rootCollectionReference.document(postID).delete { error in
            if let error {
                print(">>>>>\t", error)
                completionHandler(.failedToDeletePostDocument)
                return
            } else {
                completionHandler(nil)
            }
        }
    }
    
    
}
