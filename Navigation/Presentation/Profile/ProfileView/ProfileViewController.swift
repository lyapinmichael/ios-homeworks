//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 10.02.2023.
//

import UIKit
import StorageService

final class ProfileViewController: UIViewController {
   
    weak var rootViewController: ProfileRootViewController?
    
    // MARK: Private Properties
    
    private var timer: Timer?
    
    private var viewModel: ProfileViewModelProtocol
    
    // MARK: Subviews
    
    private lazy var mainTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        
        #if DEBUG
        view.backgroundColor = Palette.dynamicBackground
        
        #else
        view.backgroundColor = Palette.dynamicBackground
        
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
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let width = view.frame.width - 60.0
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        titleLabel.text = viewModel.user.login
        titleLabel.textColor = Palette.dynamicText
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .left
        titleLabel.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        titleLabel.backgroundColor = Palette.dynamicBars
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
       
        if let toastController = self.presentedViewController as? ToastContoller {
            toastController.dismiss(animated: true)
        }
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        mainTableView.frame = view.frame        
    }
    
    // MARK: Public methods
    
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
    
    // MARK: Private methods
    
    private func setupView() {
        setupProfileView()
        setupSubviews()
        
        let revealMenu = UIAction { [weak self] _ in
            guard let self else { return }
            print("Should Present overlapping view")
            
            self.rootViewController?.showSlideOverMenu()
        }
                
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), primaryAction: revealMenu)
        menuButton.tintColor = Palette.accentOrange
        
        navigationItem.rightBarButtonItem = menuButton
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = Palette.dynamicBars
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    private func setupProfileView() {
        mainTableView.rowHeight = UITableView.automaticDimension
        
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0.0
        }
                
        
        mainTableView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.post.rawValue
        )
        
        mainTableView.register(
            PhotosTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.photos.rawValue)

        mainTableView.register(
            UITableViewHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier: HeaderFooterReuseID.profileFooter.rawValue)
        
        mainTableView.register(
            ProfileHeaderView.self,
            forHeaderFooterViewReuseIdentifier: HeaderFooterReuseID.profileHeader.rawValue
        )
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
    }
    
    private func setupSubviews() {
        view.addSubview(mainTableView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: view.topAnchor),
            mainTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
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
            case .didReceiveUserData:
                let currentOffset = mainTableView.contentOffset
                mainTableView.reloadData()
                mainTableView.setContentOffset(currentOffset, animated: false)
            }
        }
    }
  
    // MARK: Objc methods
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: Private Types
    
    private enum CellReuseID: String {
            case base = "BaseTableViewCell_ReuseID"
            case post = "CustomTableViewCell_ReuseID"
            case photos = "PhotosTablewViewCell_ReuseID"
        }
        
    private enum HeaderFooterReuseID: String {
        case profileHeader = "ProfileSectionHeader_ReuseID"
        case profileFooter = "ProfileSectionFooter_ReuseID"
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
                for: indexPath) as! PostTableViewCell
            cell.delegate = self
            let postData = viewModel.postData[indexPath.row]
            cell.updateContent(post: postData)
            return cell
        }
    }
}

// MARK: - Table View delegate extension

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let profileHeader = ProfileHeaderView()
            profileHeader.delegate = self
            profileHeader.update(with: viewModel.user)
            return profileHeader
        } else {
            return UIView()
        }
    }
    
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
    
    func presentEditProfileViewController() {
        let editProfileViewModel = EditProfileViewModel(self.viewModel.user)
        let editProfileViewContoller = EditProfileViewController(viewModel: editProfileViewModel)
        editProfileViewContoller.modalPresentationStyle = .fullScreen
        
        self.present(editProfileViewContoller, animated: true)
    }
    
    func setTabBarColor(_ color: UIColor) {
        tabBarController?.tabBar.standardAppearance.backgroundColor = color
    }
    
    func isScrollAndSelectionEnabled(_ flag: Bool) {
        switch flag {
        case true:
            mainTableView.isScrollEnabled = true
            mainTableView.allowsSelection = true
        case false:
            mainTableView.isScrollEnabled = false
            mainTableView.allowsSelection = false
        }
    }
    
    func printStatus(_ status: String) {
        viewModel.updateState(withInput: .didTapPrintStatusButton(status))
    }
    
    func setStatus(_ status: String) {
        viewModel.updateState(withInput: .didTapSetStatusButton(status))
    }
    
    
}

extension ProfileViewController: SlideOverMenuDelegate {
    
    func slideOverMenu(_ slideOverMenu: SlideOverMenuViewController, didTap logOutButton: UIButton) {
        viewModel.updateState(withInput: .didTapLogOutButton)
        slideOverMenu.hide()
    }
    
    
}

