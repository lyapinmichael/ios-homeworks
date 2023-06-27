//
//  FavouritePostsTableController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 23.06.2023.
//

import UIKit
import StorageService

class FavouritePostsTableController: UITableViewController {
    
    weak var coordinator: FavouritePostsCoordinator?
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
            
            self.presentTextPicker(title: "Filter by Author", message: "Enter Author's name to filter posts", completion: {text in
                self.posts = FavouritePostsService.shared.filterByAuthorName(text)
                UIView.transition(with: self.tableView, duration: 0.4, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
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
            self.posts = FavouritePostsService.shared.favouritePosts
            UIView.transition(with: self.tableView, duration: 0.4, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
            self.isFiltered = false
        }
        
        let button = UIBarButtonItem(systemItem: .cancel, primaryAction: action)
        button.isEnabled = isFiltered
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posts = FavouritePostsService.shared.favouritePosts
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postCell")
        
        navigationItem.title = "Favourite posts"

        navigationItem.rightBarButtonItems = [searchBarButton, discardSearchBarButton]
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        posts = FavouritePostsService.shared.favouritePosts
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        cell.selectionStyle = .none
        let favPost = posts[indexPath.row]
        let post = Post(title: favPost.title ?? "nil",
                        author: favPost.author?.name ?? "Unknown author",
                        description: favPost.text,
                        image: favPost.imageName,
                        likes: Int(favPost.likes),
                        views: Int(favPost.views))
        (cell as? PostTableViewCell)?.updateContent(post)
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FavouritePostsService.shared.delete(atIndex: indexPath.row)
            posts = FavouritePostsService.shared.favouritePosts
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }

}
