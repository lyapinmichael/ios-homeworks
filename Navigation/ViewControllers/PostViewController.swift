//
//  PostViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 10.02.2023.
//

import UIKit

class PostViewController: UIViewController {
    
    private lazy var barButtonItem: UIBarButtonItem = {
        var barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "info.circle")
        barButton.target = self
        barButton.action = #selector(barButtronPressed(_:))
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        navigationItem.rightBarButtonItem = barButtonItem
        
    }
    
    @objc private func barButtronPressed(_ sender: UIBarButtonItem) {
        let infoViewController = InfoViewController()
        infoViewController.modalPresentationStyle = .pageSheet
        present(infoViewController, animated: true)
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
