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
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Feed"
        view.backgroundColor = .white
        
        view.addSubview(button)
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([button.leadingAnchor.constraint(
            equalTo: safeAreaGuide.leadingAnchor,
            constant: 20.0
        ),
        button.trailingAnchor.constraint(
            equalTo: safeAreaGuide.trailingAnchor,
            constant: -20.0
        ),
        button.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
        button.heightAnchor.constraint(equalToConstant: 44.0)])
        
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        
    }
    
    @objc func buttonPressed (_ sender: UIButton) {
        
        let post = Post(title: "This is a new post")
        let postViewController = PostViewController()
        postViewController.title = post.title
        navigationController?.pushViewController(postViewController, animated: true)
        
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
