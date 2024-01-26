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
    
    private lazy var loadingDimmingViewController = LoadingDimmingViewController()
    
   
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
        
        setupNavigationItem()
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
    
    private func setupNavigationItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "feed".localized)
        navigationItem.backBarButtonItem?.setTitleTextAttributes([.foregroundColor: Palette.dynamicText], for: .normal)
    }
    
    private func setupView() {
        setupProfileView()
        setupSubviews()
        
        let revealMenu = UIAction { [weak self] _ in
            guard let self else { return }
            
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
                self.presentedViewController?.dismiss(animated: true)
            case .didReceiveUserData:
                let currentOffset = mainTableView.contentOffset
                self.mainTableView.reloadData()
                self.mainTableView.setContentOffset(currentOffset, animated: false)
                self.viewModel.updateState(withInput: .didFinishUpdatingUI)
            case .waiting:
                loadingDimmingViewController.show(on: self)
            case .postDeletedSuccessfully:
                loadingDimmingViewController.hide()
                self.presentToast(message: "postDeleted".localized)
            case .failedToDeletePost:
                loadingDimmingViewController.hide()
                self.presentAlert(message: "failedToDeletePost".localized,
                             title: "errorOccured".localized)
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
            cell.passRepository(viewModel.repository)
            let postData = viewModel.postData[indexPath.row]
            cell.updateContent(post: postData, authorDisplayName: viewModel.user.fullName)
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
            profileHeader.update(postsAmount: viewModel.postData.count)
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
        } else {
            if let postCell = tableView.cellForRow(at: indexPath) as? PostTableViewCell,
               let post = postCell.post {
                let image = postCell.image
                let postDetailedViewController = PostDetailedViewController(post: post, postImage: image)
                navigationController?.pushViewController(postDetailedViewController, animated: true)
            }
        }
    }
    
    
}


// MARK: - Profile Header delegate extension

extension ProfileViewController: ProfileHeaderViewDelegate {
    
    func profileHeaderViewDidTapNewPostButton(_ profileHeaderView: ProfileHeaderView) {
        presentedViewController?.dismiss(animated: true)
        let newPostViewModel = NewPostViewModel(repository: viewModel.repository)
        let newPostViewController = NewPostViewController(viewModel: newPostViewModel)
        newPostViewController.modalPresentationStyle = .fullScreen
        present(newPostViewController, animated: true)
    }
    
    func profileHeaderViewDidTapEditProfileButton(_ profileHeaderView: ProfileHeaderView) {
        let editProfileViewModel = EditProfileViewModel(repository: viewModel.repository)
        editProfileViewModel.delegate = viewModel
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
    
    
}

// MARK: - SlideOverMenuDelegate

extension ProfileViewController: SlideOverMenuDelegate {
    
    func slideOverMenu(_ slideOverMenu: SlideOverMenuViewController, didTap logOutButton: UIButton) {
        viewModel.updateState(withInput: .didTapLogOutButton)
        slideOverMenu.hide()
    }
    
    
}

// MARK: - PostTableViewCellDelegate

extension ProfileViewController: PostTableViewCellDelegate {
    
    func postTableViewCell(_ postTableViewCell: PostTableViewCell, askToPresentToastWithMessage message: String) {
        presentToast(message: message)
    }
    
    func postTableViewCell(_ postTableViewCell: PostTableViewCell, didTapButton button: UIButton, actionsFor post: Post) {
        presentedViewController?.dismiss(animated: true)
        let postActionsViewController = PostActionsViewController(actionsFor: post)
        postActionsViewController.delegate = self
        postActionsViewController.modalPresentationStyle = .popover
        guard let popoverViewController = postActionsViewController.popoverPresentationController else { return }
        popoverViewController.delegate = self
        popoverViewController.sourceView = button
        popoverViewController.permittedArrowDirections = .up
        popoverViewController.sourceRect = CGRect(x: button.bounds.midX,
                                                  y: button.bounds.maxY +  5,
                                                  width: 0,
                                                  height: 0)
        present(postActionsViewController, animated: true)
        
    }
    
    
}

// MARK: - UIPopoverPresentationControllerDelegate

extension ProfileViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}

// MARK: - PostActionsViewControllerDelegate

extension ProfileViewController: PostActionsViewControllerDelegate {
    func postActionsViewController(_ postActionsViewController: PostActionsViewController, didTapDeleteButton button: UIButton, forPost post: Post) {
        presentedViewController?.dismiss(animated: true)
        presentAlert(message: "sureToDelete".localized,
                     title: "deletePost".localized, 
                     actionTitle: "delete".localized,
                     actionStyle: .destructive,
                     feedBackType: .warning,
                     addCancelAction: true) { [weak self] in 
            self?.viewModel.updateState(withInput: .deletePost(post))
        }
    }
    
    func postActionsViewController(_ postActionsViewController: PostActionsViewController, didTapShareButton button: UIButton, forPost post: Post) {
        return
    }
    

}
