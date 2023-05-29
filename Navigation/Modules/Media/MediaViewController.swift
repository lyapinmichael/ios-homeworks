//
//  MediaViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 27.05.2023.
//

import UIKit

final class MediaViewController: UIViewController {
    
    //MARK: Public properties
    
    var coordinator: MediaCoordinator?
    
    // MARK: Private properties
    
    private lazy var contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        stackView.axis = .vertical
        
        stackView.distribution = .fillEqually
        
        let musicPlayerViewModel = MusicPlayerViewModel()
        let musicPlayer = MusicPlayer(viewModel: musicPlayerViewModel)
        
        stackView.addArrangedSubview(musicPlayer)

        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Media"
        setup()
    }
    
    // MARK: Private methods
    
    private func setup() {
        view.addSubview(contentView)
        setConstraints()
    }
    
    private func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
       

            contentView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
   
}

