//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 10.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
   
    // MARK: - Data
    
    fileprivate let postData = Post.make()
    
    // MARK: - Private Properties. Subviews
    
    private lazy var profileView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .systemGray5
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private enum CellReuseID: String {
            case base = "BaseTableViewCell_ReuseID"
            case post = "CustomTableViewCell_ReuseID"
            case photos = "PhotosTablewViewCell_ReuseID"
        }
        
    private enum HeaderFooterReuseID: String {
        case profileHeader = "ProfileSectionHeader_ReuseID"
        case profileFooter = "ProfileSectionFooter_ReuseID"
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        viewWillLayoutSubviews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        profileView.frame = view.frame        
    }
    
    
    
    
    
    // MARK: - Private methods
    
    private func setupView() {
        title = "Profile"
        addSubviews()
        setupProfileView()
        setConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(profileView)
    }
    
    private func setupProfileView() {
        profileView.rowHeight = UITableView.automaticDimension
        
        if #available(iOS 15.0, *) {
            profileView.sectionHeaderTopPadding = 0.0
        }
        
        let profileHeader = ProfileHeaderView()
        profileView.setAndLayout(headerView: profileHeader)
        
        
        profileView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.post.rawValue
        )
        
        profileView.register(
            PhotosTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.photos.rawValue)

        profileView.register(
            UITableViewHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier: HeaderFooterReuseID.profileFooter.rawValue)
        
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
  
    // MARK: - Objc methods
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - TableView Data Source extension

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section == 0 {
            return 1
        } else {
            return postData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.photos.rawValue, for: indexPath) as! PhotosTableViewCell
            cell.setup(tableView.frame)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.post.rawValue,
                for: indexPath
            ) as! PostTableViewCell
            cell.updateContent(postData[indexPath.row])
            return cell
        }
    }
    
}

// MARK: - Table View delegate extension

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderFooterReuseID.profileFooter.rawValue)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20.0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            let photosCollection = PhotosViewController()
            photosCollection.title = "Photo gallery"
            navigationController?.isNavigationBarHidden = false
            navigationController?.pushViewController(photosCollection, animated: true)
        }
    }
    
}

