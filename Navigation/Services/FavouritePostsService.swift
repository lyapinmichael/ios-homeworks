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
    
    private lazy var context = persistentContainer.viewContext
    
    var favouritePosts: [FavouritePost] = []
    
    private init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        let fetchRequest = FavouritePost.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "views", ascending: true)]
        favouritePosts = (try? context.fetch(fetchRequest)) ?? []
    }
    
    func add(post: Post, completion: @escaping ((Result<Any, FavouritePostsService.FavouritePostsError>) -> Void)) {
        
        guard !favouritePosts.contains(where: {$0.uuid == post.id}) else {
            completion(.failure(.alreadyInFavourites))
            return }
        
        let newFavoutitePost = FavouritePost.init(context: context)
        newFavoutitePost.title = post.title
        newFavoutitePost.author = post.author
        newFavoutitePost.likes = Int32(post.likes)
        newFavoutitePost.views = Int32(post.views)
        newFavoutitePost.text = post.description
        newFavoutitePost.imageName = post.image
        newFavoutitePost.uuid = post.id
        
        try? context.save()
        fetchPosts()
        completion(.success(true))
    }
    
    func delete(atIndex index: Int) {
        context.delete(favouritePosts[index])
        try? context.save()
        fetchPosts()
    }
}
