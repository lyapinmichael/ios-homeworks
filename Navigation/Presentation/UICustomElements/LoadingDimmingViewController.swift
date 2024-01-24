//
//  LoadingDimmingViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 23.01.2024.
//

import UIKit

final class LoadingDimmingViewController: UIViewController {
    
    // MARK: Private properties 
    
    private var spinner = UIActivityIndicatorView(style: .large)
    
    // MARK: Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
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
    
    // MARK: Public methods
    
    func show(on viewController: UIViewController) {
        viewController.addChild(self)
        self.view.frame = viewController.view.frame
        viewController.view.addSubview(self.view)
        self.didMove(toParent: viewController)
    }
    
    func hide() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
}
