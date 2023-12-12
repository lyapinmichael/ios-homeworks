//
//  ToastContoller.swift
//  Navigation
//
//  Created by Ляпин Михаил on 18.05.2023.
//

import UIKit

class ToastContoller: UIViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("thankUser", comment: "")
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    convenience init(message: String) {
        self.init()
        label.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        view.backgroundColor = Palette.accentOrange
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            
            view.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 20)
        ])
    }
    
}

extension ToastContoller: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ToastPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}

