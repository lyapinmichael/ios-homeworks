//
//  FeedViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 10.02.2023.
//

import UIKit

class FeedViewController: UIViewController {

    
    let post = Post(title: "New Post")
    
    private lazy var  button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open Post", for: .normal)

        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        return button
    }()
    

    private func setupButtonConstraints(_ button: UIButton) {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(
                equalTo: safeAreaGuide.leadingAnchor,
                constant: 20.0
            ),
            button.trailingAnchor.constraint(
                equalTo: safeAreaGuide.trailingAnchor,
                constant: -20.0
            ),
            button.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 44.0)])
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Feed"
        view.backgroundColor = .white
        
        view.addSubview(button)

        setupButtonConstraints(button)
        
        
    }
    
    @objc func buttonPressed (_ sender: UIButton) {
        
        let post = Post(title: "This is a new post")
        let postViewController = PostViewController()
        postViewController.title = post.title
        navigationController?.pushViewController(postViewController, animated: true)
        

    }
    

}
