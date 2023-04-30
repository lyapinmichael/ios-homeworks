//
//  MainTabBarController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 11.02.2023.
//

import UIKit

class MainTabBarController: UITabBarController {

    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureAppearance()
    }
    
    private func configureAppearance() {
        
        /// Firstly setting appearance of a tab bar
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .white
        
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        
        /// Then checking is passed viewcontrollers are wrapped into navigation controllers
        guard let viewControllers = self.viewControllers else {
            print ("Something went wrong when setting viewcontrollers")
            return
        }
        
        /// And finally setting appearance of nav bar for each navigation controller
        for i in viewControllers.indices {
            
            guard let nc = (viewControllers[i] as? UINavigationController) else { return }
            
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = .white
            
            nc.navigationBar.standardAppearance = navBarAppearance
            nc.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
  
}
