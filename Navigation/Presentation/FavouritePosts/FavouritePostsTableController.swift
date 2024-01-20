//
//  FavouritePostsTableController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 23.06.2023.
//

import UIKit
import CoreData
import StorageService

class FavouritePostsTableController: UITableViewController {
    
    weak var coordinator: FavouritePostsCoordinator?
    
    var userID: String = "slkdjfslkjd"
    
    lazy var fetchResultsController = {
        
        let fetchRequest = FavouritePost.fetchRequest()
//        fetchRequest.predicate = NSPredicate(
//            format: "author.uuid == %@", "\(somestring)"
//        )
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: FavouritePostsService.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultsController
    }()
    
    private var posts: [FavouritePost] = []
    
    private var _isFiltered = false
    private var isFiltered: Bool {
        get {
            return _isFiltered
        }
        set {
            _isFiltered = newValue
            discardSearchBarButton.isEnabled = newValue
        }
    }
    
    private lazy var searchBarButton: UIBarButtonItem = {
     
        
        let action = UIAction { [weak self] _ in
            
            guard let self = self else { return }
            
            let titleString = NSLocalizedString("filterByAuthor", comment: "")
            let messageString = NSLocalizedString("enterAuthorToFilter", comment: "")
            self.presentTextPicker(title: titleString, message: messageString, completion: {text in
                
                UIView.transition(with: self.tableView, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    self.fetchResultsController.fetchRequest.predicate = NSPredicate(format: "author.name CONTAINS %@", text)
                    try? self.fetchResultsController.performFetch()
                    self.tableView.reloadData()
                    
                }, completion: nil)
                self.isFiltered = true
            })
        }
        let button = UIBarButtonItem(systemItem: .search, primaryAction: action)
        return button
    }()
    
    
    private lazy var discardSearchBarButton: UIBarButtonItem = {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            guard self.isFiltered else { return }
            
            UIView.transition(with: self.tableView, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.fetchResultsController.fetchRequest.predicate = nil
                try? self.fetchResultsController.performFetch()
                self.tableView.reloadData()
                
            }, completion: nil)
            self.isFiltered = false
        }
        
        let button = UIBarButtonItem(systemItem: .cancel, primaryAction: action)
        button.isEnabled = isFiltered
        return button
    }()
     
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Palette.dynamicBackground
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postCell")
        
        navigationItem.title = NSLocalizedString("favoritePosts", comment: "")

        navigationItem.rightBarButtonItems = [searchBarButton, discardSearchBarButton]
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchResultsController.delegate = self
        try? fetchResultsController.performFetch()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        cell.selectionStyle = .none
        let favPost = fetchResultsController.object(at: indexPath)
        
        guard let postID = favPost.uuid else { return UITableViewCell() }
        
        let post = Post(author: favPost.author?.name ?? NSLocalizedString("unknownAuthor", comment: ""),
                        description: favPost.text,
                        likes: Int(favPost.likes),
                        hasImageAttached: favPost.hasImageAttached,
                        dateCreated: favPost.dateCreated ?? Date())
        
        
        let imageData = try? CacheService.default.readPostImageCache(from: postID)
        (cell as? PostTableViewCell)?.updateContent(post: post)
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let postToDelete = fetchResultsController.object(at: indexPath)
            FavouritePostsService.shared.delete(postToDelete)
            
        }
    }

}

extension FavouritePostsTableController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .top)
            
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .middle)
            
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .bottom)
            
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
            
        @unknown default:
            ()
        }
    }
}
