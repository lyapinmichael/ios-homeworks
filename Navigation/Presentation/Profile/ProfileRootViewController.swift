//
//  ProfileRootViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 26.11.2023.
//

import Foundation
import UIKit


final class ProfileRootViewController: UIViewController {
    
    // MARK: Init
    
    init(profileViewController: ProfileViewController, slideOverMenuViewContoller: SlideOverMenuViewController) {
        
        let profileNavigationContoller = UINavigationController(rootViewController: profileViewController)
        profileNavigationContoller.navigationBar.tintColor = Palette.accentOrange
        
        super.init(nibName: nil, bundle: nil)
        
        profileViewController.rootViewController = self
        slideOverMenuViewContoller.rootViewController = self
        
        addChild(profileNavigationContoller)
        addChild(slideOverMenuViewContoller)
        
        view.addSubview(profileNavigationContoller.view)
        view.addSubview(slideOverMenuViewContoller.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    // MARK: Public methods
    
    func showSlideOverMenu() {
        if  let slideOverViewController = children.first(where: { $0 is SlideOverMenuViewController }) as? SlideOverMenuViewController
             {
            slideOverViewController.show()
            
        }
    }
    
    // MARK: Private methods
    
    private func setupSubviews() {
        
        if let slideOverViewContoller = children.first(where: { $0 is SlideOverMenuViewController}) as? SlideOverMenuViewController, 
            let slideOverView = slideOverViewContoller.view {
            slideOverView.isHidden = true
        }
    }
    
    
}
