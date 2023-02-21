//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 10.02.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let profileHeader: ProfileHeaderView = {
        let view = ProfileHeaderView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        view.backgroundColor = .lightGray
        view.addSubview(profileHeader)
        viewWillLayoutSubviews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        profileHeader.frame = view.frame
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

