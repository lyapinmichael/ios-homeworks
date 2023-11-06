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
        case failedToFetchUserDocument
        case userDocumnentDoesntExist
        case failedToDecodeUserDocument
        case failedToCreateNewUserDocument
        
        case failedToFetchPostDocument
        case postDocumentDoesntExist
        case failedToDecodePostDocument
        case failedToCreateNewPostDocument
    }
    
    // This property is crucial for further work with firestore.
    // It is received whenever user logs in, so the app knows user identity,
    // and knowing user's identity the app then makes queries into Cloud Firestore
    // to read and write user-specific data, such as posts.
    let userID: String
    
    private let dataBase = Firestore.firestore()
    
    private var rootCollectionReference: CollectionReference!
    private var documentReference: DocumentReference!
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    init(userID: String) {
        self.userID = userID
    }
    
    func fetchUserData(completionHandler: @escaping (Result<User, FirestoreServiceError>) -> Void) {
        
        rootCollectionReference = dataBase.collection("users")
        documentReference = rootCollectionReference.document(userID)
        
        documentReference.getDocument { querySnapshot, error in
            
            if let error {
                print(error)
                completionHandler(.failure(.failedToFetchUserDocument))
            }
            
            guard let userDocument = querySnapshot, userDocument.exists  else {
                completionHandler(.failure(.userDocumnentDoesntExist))
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
    
    func writeUserDocument(_ user: User, completionHandler: @escaping () -> Void) {
        
        do {
            try dataBase.collection("users").document(user.id).setData(from: user)
            completionHandler()
        } catch {
            print(error)
        }
        
    }
}
