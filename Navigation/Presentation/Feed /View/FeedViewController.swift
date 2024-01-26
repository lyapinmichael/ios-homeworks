//
//  FeedViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 10.02.2023.
//

import UIKit
import StorageService
import ESPullToRefresh

final class FeedViewController: UIViewController {
    
    // MARK: Public properties
    
    weak var coordinator: FeedCoordinator?
    
    // MARK: Private properties
    
    private let viewModel = FeedViewModel()
    
    // MARK: Subviews
    
    private lazy var feedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        tableView.register(PostTableViewCell.self,
                           forCellReuseIdentifier: PostTableViewCell.reuseID)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.es.addPullToRefresh { [weak self] in
            self?.viewModel.updateState(withInput: .didPullToRefresh) {
                tableView.es.stopPullToRefresh()
            }
        }
    
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
        
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()
        setupSubviews()
        bindViewModel()
        
        title = NSLocalizedString("feed", comment: "")
        
        view.backgroundColor = Palette.dynamicBackground
    }
    
    // MARK: Private methods
    
    private func setupNavigationItem() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackIndicatorImage")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackIndicatorImage")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "feed".localized)
        navigationItem.backBarButtonItem?.setTitleTextAttributes([.foregroundColor: Palette.dynamicText], for: .normal)
    }
    
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            switch state {
            case .initial:
                return
            case .didReceivePosts:
                self?.feedTable.reloadData()
            }
        }
    }
    
    private func setupSubviews() {
        view.addSubview(feedTable)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
        
            feedTable.topAnchor.constraint(equalTo: safeArea.topAnchor),
            feedTable.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            feedTable.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            feedTable.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        
        ])
    }
}

// MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDataSource {
 
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.postsByDate.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.postsByDate[section].posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseID) as? PostTableViewCell else { return UITableViewCell() }
        let post = viewModel.postsByDate[indexPath.section].posts[indexPath.row]
        cell.updateContent(post: post)
        cell.isActionsButtonHidden = true
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let date = viewModel.postsByDate[section].date
        return FeedTableSectionHeaderView(date: date)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let postCell = tableView.cellForRow(at: indexPath) as? PostTableViewCell,
           let post = postCell.post {
            let image = postCell.image
            let postDetailedViewController = PostDetailedViewController(post: post, postImage: image)
            navigationController?.pushViewController(postDetailedViewController, animated: true)
        }
    }
    
    
}
