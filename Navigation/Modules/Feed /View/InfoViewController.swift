//
//  InfoViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 11.02.2023.
//

import UIKit

final class InfoViewController: UIViewController {
    
    private enum CellID: String {
        case base = "baseCellID"
    }
    
    // MARK: - Private properties
    
    private var residents: [PlanetResident] = []
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var todoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.clipsToBounds = true
        label.layer.cornerRadius = 20
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.firstLineHeadIndent = 10
        paragraphStyle.headIndent = 10
        
        let attributedString = NSAttributedString(string: "Loading...",
                                                  attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        label.attributedText = attributedString
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var planetOrbitPeriodLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.clipsToBounds = true
        label.layer.cornerRadius = 20
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.firstLineHeadIndent = 10
        paragraphStyle.headIndent = 10
        
        let attributedString = NSAttributedString(string: "Loading...",
                                                  attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        label.attributedText = attributedString
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        
        tableView.layer.cornerRadius = 20
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.systemGray.cgColor
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellID.base.rawValue)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupSubviews()
        
        getTodo()
        getPlanetData()
        
        
    }
    
    // MARK: - Private methods
    
    private func setupSubviews() {
        
        
        view.addSubview(contentView)
        contentView.addSubview(todoLabel)
        contentView.addSubview(planetOrbitPeriodLabel)
        contentView.addSubview(tableView)
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            
            todoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            todoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            todoLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16),
            todoLabel.heightAnchor.constraint(equalToConstant: 80),
            
            planetOrbitPeriodLabel.topAnchor.constraint(equalTo: todoLabel.bottomAnchor, constant: 16),
            planetOrbitPeriodLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            planetOrbitPeriodLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16),
            planetOrbitPeriodLabel.heightAnchor.constraint(equalToConstant: 80),
            
            tableView.topAnchor.constraint(equalTo: planetOrbitPeriodLabel.bottomAnchor, constant: 16),
            tableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            
        ])
    }
    
    // Presents an alert informing that something went wrong
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
    
    
    // Loads Todo item from API
    private func getTodo() {
        
        NetworkService.requestTodo(number: 70) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let todo):
                
                DispatchQueue.main.async {
                    self.todoLabel.text = todo.title
                }
                
            case .failure(let error):
                
                print(error)
                
                DispatchQueue.main.async {
                    self.todoLabel.text = "Failed to load data"
                    self.presentAlert()
                }
            }
            
        }
    }
    
    // Loads data about specific planet form SWApi
    private func getPlanetData() {
        
        NetworkService.requestPlanetData(number: 1) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let planetData):
                
                self.getResidentsData(residentURLs: planetData.residents)
                
                DispatchQueue.main.async {
                    self.planetOrbitPeriodLabel.text = "\(planetData.name)'s orbital period is \(planetData.orbitalPeriod) days."
                }
                
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.planetOrbitPeriodLabel.text = "Failed to load data"
                    self.presentAlert()
                }
                
                print(error)
            }
        }
    }
    
    private func getResidentsData(residentURLs: [String]) {
        
        self.residents = []
        let dispatchGroup = DispatchGroup()
        
        for i in residentURLs {
            dispatchGroup.enter()
            NetworkService.requestRezidentsOfPlanet(urlString: i, completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let resident):
                    self.residents.append(resident)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
                dispatchGroup.leave()
            })
            
        }
        
        dispatchGroup.notify(queue: .main, execute: {
     
                self.tableView.reloadData()
        })
    }
}

extension InfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return residents.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID.base.rawValue) else {
            let cell = UITableViewCell()
            return cell
        }
        cell.backgroundColor = .systemGray6
        var configutation = UIListContentConfiguration.cell()
        configutation.text = residents[indexPath.row].name
        cell.contentConfiguration = configutation
        
        return cell
        
    }
}

extension InfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List of planet residents:"
    }
}
