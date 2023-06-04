//
//  InfoViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 11.02.2023.
//

import UIKit

final class InfoViewController: UIViewController {
    
    // MARK: - Private properties
    
    private lazy var mainStack: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        
        stackView.addArrangedSubview(todoLabel)
        stackView.addArrangedSubview(getTodoButton)
        stackView.addArrangedSubview(getPlanetOrbitalPeriodButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var todoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray5
        label.clipsToBounds = true
        label.layer.cornerRadius = 20

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.firstLineHeadIndent = 10
        paragraphStyle.headIndent = 10
        
        let attributedString = NSAttributedString(string: "Press button below",
                                                  attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        label.attributedText = attributedString
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return label
    }()
    
    private lazy var getTodoButton: UIButton = {
        
        var button = UIButton()

        button.setTitle("Press to request Todo from API", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        
        button.addTarget(self, action: #selector(getTodo(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var getPlanetOrbitalPeriodButton: UIButton = {
        
        var button = UIButton()

        button.setTitle("Press to request Planet's orbital period", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        
        button.addTarget(self, action: #selector(getPlanetsOrbitalPeriod), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(mainStack)
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        var stackHeight: CGFloat  { CGFloat (self.mainStack.arrangedSubviews.count) * 80
        }
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 20.0),
            mainStack.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -20.0),
            mainStack.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            mainStack.heightAnchor.constraint(equalToConstant: stackHeight)
        ])
        
        
    }

    // MARK: - Private methods
    
    private func presentAlert() {
        let title = "Error occured"
        let message = "Something went wrong while trying to get requested information. Please, try again later."
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
       
        
        let closeHandler: ((UIAlertAction) -> Void) = {_ in
            alert.dismiss(animated: true)
        }
        
        let close = UIAlertAction(title: "Close", style: .default, handler: closeHandler)
        
        
        alert.addAction(close)
        
        present(alert, animated: true)
    }
    
    // MARK: - Objc methods
    
    @objc private func getTodo(_ sender: UIButton) {
        
        NetworkService.requestTodo(number: 73) { result in
            switch result {
            case .success(let todo):
                
                DispatchQueue.main.async {
                    self.todoLabel.text = todo.title
                }
                
            case .failure(let error):
                
                print(error)
                
                DispatchQueue.main.async {
                    self.presentAlert()
                }
            }
            
        }
    }
    
    @objc private func getPlanetsOrbitalPeriod() {
        
        NetworkService.requestTatooineOrbitalPeriod(number: 1) { result in
            switch result {
            case .success(let planetData):
                
                DispatchQueue.main.async {
                    self.todoLabel.text = "\(planetData.name)'s orbital period is \(planetData.orbitalPeriod) days."
                }
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.presentAlert()
                }
                
                print(error)
            }
        }
        
        
    }

}
