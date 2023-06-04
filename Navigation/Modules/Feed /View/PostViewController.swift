//
//  PostViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 10.02.2023.
//

import UIKit

class PostViewController: UIViewController {
    
    weak var coordinator: FeedCoordinator?
    
    private lazy var barButtonItem: UIBarButtonItem = {
        var barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "info.circle")
        barButton.target = self
        barButton.action = #selector(barButtronPressed(_:))
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        view.backgroundColor = .systemYellow

        navigationItem.rightBarButtonItem = barButtonItem
        
    }
    
    @objc private func barButtronPressed(_ sender: UIBarButtonItem) {
        
        coordinator?.present(.info)
        
    }
    
}
