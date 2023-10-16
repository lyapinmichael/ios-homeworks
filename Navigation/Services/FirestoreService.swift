//
//  FirestoreService.swift
//  Navigation
//
//  Created by Ляпин Михаил on 16.10.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


final class FirestoreService {
    
    enum FirestoreServiceError: Error {
        case failedToFetchUserDocument
        case userDocumnentDoesntExist
        case failedToDecodeUserDocument
    }
    
    let userID: String
    
    private let dataBase = Firestore.firestore()
    
    private var rootCollectionReference: CollectionReference!
    private var documentReference: DocumentReference!
    
    private let decoder = JSONDecoder()
    
    init(userID: String) {
        self.userID = userID
    }
    
    func fetchUserData(_ completionHandler: @escaping (Result<User, FirestoreServiceError>) -> Void) {
        
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
    
    //TODO: Implement commiting updates to user in firestore
    func updateUserData(_ updatedUser: User) {
        
    }
}
