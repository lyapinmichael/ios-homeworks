//
//  MainTabBarController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 11.02.2023.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTabBarController()

    }
    
    private func createTabBarController() {
        
        let profileViewController = createNavigationController(root: ProfileViewController(), title: "Profile", image: "person.circle")
        let feedViewController = createNavigationController(root: FeedViewController(), title: "Feed", image: "house.circle")
        
        viewControllers = [feedViewController, profileViewController]
        
        
    }
    
    private func createNavigationController(root: UIViewController, title: String, image: String) -> UINavigationController {
        
        let navigationItem = UITabBarItem(title: title, image: UIImage(systemName: image), tag: 0)
        
        let navigationController = UINavigationController(rootViewController: root)
        
        navigationController.tabBarItem = navigationItem
        
        return (navigationController)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
