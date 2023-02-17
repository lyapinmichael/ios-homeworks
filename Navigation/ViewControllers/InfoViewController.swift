//
//  InfoViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 11.02.2023.
//

import UIKit

class InfoViewController: UIViewController {
    
    private lazy var button: UIButton = {
        
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Press for Alert", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(button)
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 20.0),
            button.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -20.0),
            button.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 44.0)
        ])
        
        button.addTarget(self, action: #selector(buttonIsPressed(_:)), for: .touchUpInside)
        
    }
    
    @objc private func buttonIsPressed(_ sender: UIButton) {
        
        let alert = UIAlertController()
        alert.title = "Choose a pill Neo"
        alert.message = "You take the blue pill - the story ends, you wake up in your bed and believe whatever you want to believe. You take the red pill - you stay in Wonderland and I show you how deep the rabbit hole goes."
        
        let blueHandler: ((UIAlertAction) -> Void) = {_ in
            print ("You have chosen the blue pill.")
        }
        
        let redHandler: ((UIAlertAction) -> Void) = {_ in
            print ("You have chose the red pill.")
        }
        
        let blueAcion = UIAlertAction(title: "Blue", style: .default, handler: blueHandler)
        let redAction = UIAlertAction(title: "Red", style: .default, handler: redHandler)
        
        alert.addAction(blueAcion)
        alert.addAction(redAction)
        
        present(alert, animated: true)
        
    }
    
    
    
    
}
