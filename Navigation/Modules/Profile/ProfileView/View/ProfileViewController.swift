//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 10.02.2023.
//

import UIKit
import StorageService

final class ProfileViewController: UIViewController {
   
    //MARK: - Private enums for cells and header reuse is
    
    private enum CellReuseID: String {
            case base = "BaseTableViewCell_ReuseID"
            case post = "CustomTableViewCell_ReuseID"
            case photos = "PhotosTablewViewCell_ReuseID"
        }
        
    private enum HeaderFooterReuseID: String {
        case profileHeader = "ProfileSectionHeader_ReuseID"
        case profileFooter = "ProfileSectionFooter_ReuseID"
    }

    
    // MARK: - Private Properties. Subviews
    
    private var timer: Timer?
    
    private var viewModel: ProfileViewModelProtocol
    
    private lazy var profileView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        
        #if DEBUG
        view.backgroundColor = .systemGray5
        
        #else
        view.backgroundColor = .white
        
        #endif
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
   
    // MARK: - Init
    
    init(with viewModel: ProfileViewModelProtocol) {
    
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Deinit
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        viewWillLayoutSubviews()
        bindViewModel()
        presentToast()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        let logOutAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.updateState(withInput: .didTapLogOutButton)
        }
        
        let logOutString = NSLocalizedString("logOut", comment: "")
        let logOutButton = UIBarButtonItem(title: logOutString, primaryAction: logOutAction)
        navigationItem.rightBarButtonItem = logOutButton

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
        self.presentedViewController?.dismiss(animated: true)
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
        profileHeader.delegate = self
        profileHeader.update(with: viewModel.user)
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

    func presentToast(message: String? = nil) {
        
        var toast: ToastContoller
        
        if let message = message {
            toast = ToastContoller(message: message)
        } else {
            toast = ToastContoller()
        }
        

        present(toast, animated: true)
        
        timer = Timer.scheduledTimer(withTimeInterval: 3,
                                     repeats: false,
                                     block: { _ in
            toast.dismiss(animated: true)
        })
        timer?.tolerance = 0.3
        
        
    }
    //MARK: - Public methods
    
    func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .initial:
                print("Initial state")
            case let .printStatus(status):
                print (status)
            case let .setStatus(status):
                self.viewModel.user.status = status
                print ("Status set to \"\(status)\"")
            }
        }
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
            return viewModel.postData.count
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
            cell.delegate = self
            cell.updateContent(viewModel.postData[indexPath.row])
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
            photosCollection.title = NSLocalizedString("photoGallery", comment: "")
            navigationController?.isNavigationBarHidden = false
            navigationController?.pushViewController(photosCollection, animated: true)
        }
    }
    
}


// MARK: - Profile Header delegate extension

extension ProfileViewController: ProfileHeaderViewDelegate {
    
    func setTabBarColor(_ color: UIColor) {
        tabBarController?.tabBar.standardAppearance.backgroundColor = color
    }
    
    func isScrollAndSelectionEnabled(_ flag: Bool) {
        switch flag {
        case true:
            profileView.isScrollEnabled = true
            profileView.allowsSelection = true
        case false:
            profileView.isScrollEnabled = false
            profileView.allowsSelection = false
        }
    }
    
    func printStatus(_ status: String) {
        viewModel.updateState(withInput: .didTapPrintStatusButton(status))
    }
    
    func setStatus(_ status: String) {
        viewModel.updateState(withInput: .didTapSetStatusButton(status))
    }
}

