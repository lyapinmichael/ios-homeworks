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
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavouritePost")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("CoreData error: " + error.localizedDescription)
            }
        })
        return container
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return context
    }()
    
    var favouritePosts: [FavouritePost] = []
    
    private init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        let fetchRequest = FavouritePost.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "views", ascending: true)]
        favouritePosts = (try? backgroundContext.fetch(fetchRequest)) ?? []
    }
    
    func add(post: Post, completion: @escaping ((Result<Any, FavouritePostsService.FavouritePostsError>) -> Void)) {
        
        guard !favouritePosts.contains(where: {$0.uuid == post.id}) else {
            completion(.failure(.alreadyInFavourites))
            return }
     
        /// Этот метод можно было бы оставить с предыдущей реализацией, заменив только свойство background context, но я решил попрактиковаться и сделать его таким образом.
        
        self.persistentContainer.performBackgroundTask({ [weak self] backgroundContext in
            let author = Author.init(context: backgroundContext)
            author.name = post.author
            
            let newFavoutitePost = FavouritePost.init(context: backgroundContext)
            newFavoutitePost.title = post.title
            newFavoutitePost.author = author
            newFavoutitePost.likes = Int32(post.likes)
            newFavoutitePost.views = Int32(post.views)
            newFavoutitePost.text = post.description
            newFavoutitePost.imageName = post.image
            newFavoutitePost.uuid = post.id
            
            
            try? backgroundContext.save()
            
            DispatchQueue.main.async {
                self?.fetchPosts()
                completion(.success(true))
            }
        })
    }
    
    func delete(atIndex index: Int) {
        backgroundContext.delete(favouritePosts[index])
        try? backgroundContext.save()
        fetchPosts()
    }
    
    func filterByAuthorName(_ authorName: String) -> [FavouritePost] {
        let fetchRequest = FavouritePost.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "author.name CONTAINS %@", authorName)
        return (try? backgroundContext.fetch(fetchRequest)) ?? []
    }
}
