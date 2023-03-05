//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 10.02.2023.
//

import UIKit

class ProfileViewController: UIViewController {
   
    // MARK: - Data
    
    fileprivate let data = Post.make()
    
    // MARK: - Private Properties. Subviews
    
    private lazy var profileView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private enum CellReuseID: String {
            case base = "BaseTableViewCell_ReuseID"
            case custom = "CustomTableViewCell_ReuseID"
        }
        
    private enum HeaderFooterReuseID: String {
        case profileHeader = "ProfileSectionHeader_ReuseID"
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        viewWillLayoutSubviews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        profileView.frame = view.frame
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        title = "Profile"
        view.backgroundColor = .lightGray
        addSubviews()
        setupProfileView()
        setConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(profileView)
    }
    
    private func setupProfileView() {
        profileView.rowHeight = UITableView.automaticDimension
        profileView.sectionHeaderHeight = UITableView.automaticDimension
        
        if #available(iOS 15.0, *) {
            profileView.sectionHeaderTopPadding = 0.0
        }
        
        let profileHeader = ProfileHeaderView()
        profileView.setAndLayout(headerView: profileHeader)
        
        
        profileView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.custom.rawValue
        )
        
        profileView.register(
            UITableViewHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier: HeaderFooterReuseID.profileHeader.rawValue)
        
        profileView.delegate = self
        profileView.dataSource = self
        
    }
    
    private func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - TableView Data Source extension

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellReuseID.custom.rawValue,
            for: indexPath
        ) as? PostTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        cell.updateContent(data[indexPath.row])
        
        return cell
    }
    
}

// MARK: - Table View delegate extension

extension ProfileViewController: UITableViewDelegate {
    
    
}

