//
//  FavouritePostsService.swift
//  StorageService
//
//  Created by Ляпин Михаил on 23.06.2023.
//

import Foundation
import CoreData
import StorageService
import UIKit

final class FavouritePostsService {
    
    static var shared = FavouritePostsService()
    
    enum FavouritePostsError: Error {
        case alreadyInFavourites
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavouritePost")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error as NSError? {
                print("CoreData error: " + error.localizedDescription)
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    private init() {
    }
    
    func checkIsPostSaved(_ post: Post, completion: @escaping (Bool) -> Void = { _ in }) {
        guard let postID = post.id else { return  }
        let fetchRequest: NSFetchRequest<FavouritePost> = FavouritePost.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", postID)
        persistentContainer.performBackgroundTask { context in
            do {
                let count = try context.count(for: fetchRequest)
                DispatchQueue.main.async {
                    completion(count > 0)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                    print(">>>>>\t", error)
                }
            }
        }
    }
    
    func add(post: Post, completion: @escaping ((Result<Any, FavouritePostsService.FavouritePostsError>) -> Void)) {
        
        self.persistentContainer.performBackgroundTask({ backgroundContext in
            
            let author = Author.init(context: backgroundContext)
            author.name = post.author
            author.uuid = post.authorID
            
            let newFavoutitePost = FavouritePost.init(context: backgroundContext)
            
            newFavoutitePost.hasImageAttached = post.hasImageAttached
            newFavoutitePost.author = author
            newFavoutitePost.likes = Int32(post.likes)
            newFavoutitePost.dateCreated = post.dateCreated.dateValue()
            newFavoutitePost.text = post.description
            newFavoutitePost.uuid = post.id
            newFavoutitePost.dateAdded = Date()
            
            
            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.alreadyInFavourites))
                }
                print(error.localizedDescription)
            }
            
           
        })
    }
    
    func delete(_ postToDelete: FavouritePost) {
        persistentContainer.performBackgroundTask({context in
            let postInBackgoundContext = context.object(with: postToDelete.objectID)
            context.delete(postInBackgoundContext)
            try? context.save()
        })
    }
    
    func delete(_ postToDelete: Post) {
        guard let postID = postToDelete.id else { return }
        let fetchRequest = FavouritePost.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", "\(postID)")
        persistentContainer.performBackgroundTask {context in
            do {
                let entities = try context.fetch(fetchRequest)
                for entity in entities {
                    context.delete(entity)
                }
                try context.save()
            } catch {
                print(">>>>>\t", error)
            }
        }
    }
    
    
}
