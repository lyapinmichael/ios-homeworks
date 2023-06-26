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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posts = FavouritePostsService.shared.favouritePosts
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postCell")
        navigationItem.title = "Favourite posts"
        
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
        let favPost = posts[indexPath.row]
        let post = Post(title: favPost.title ?? "nil",
                        author: favPost.author ?? "Unknown author",
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
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
