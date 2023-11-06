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
    
    var favouritePosts: [FavouritePost] = []
    
    private init() {
    }
    
    func add(post: Post, completion: @escaping ((Result<Any, FavouritePostsService.FavouritePostsError>) -> Void)) {
        
        self.persistentContainer.performBackgroundTask({ backgroundContext in
            
            let author = Author.init(context: backgroundContext)
            author.name = post.author
            author.uuid = post.authorID
            
            let newFavoutitePost = FavouritePost.init(context: backgroundContext)
            
            newFavoutitePost.title = post.title
            newFavoutitePost.author = author
            newFavoutitePost.likes = Int32(post.likes)
            newFavoutitePost.views = Int32(post.views)
            newFavoutitePost.text = post.description
            newFavoutitePost.imageName = post.imageURL
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
}
