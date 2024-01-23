//
//  LoadingDimmingViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 23.01.2024.
//

import UIKit

final class LoadingDimmingViewController: UIViewController {
    
    private var spinner = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = Palette.dynamicBackground.withAlphaComponent(0.4)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
}
