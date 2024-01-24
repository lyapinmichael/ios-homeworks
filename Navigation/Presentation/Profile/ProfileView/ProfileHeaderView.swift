//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Ляпин Михаил on 13.02.2023.
//

import UIKit

protocol ProfileHeaderViewDelegate: AnyObject {
    
    func setTabBarColor(_ color: UIColor)
    func isScrollAndSelectionEnabled(_ flag: Bool)
    func profileHeaderViewDidTapEditProfileButton(_ profileHeaderView: ProfileHeaderView)
    func profileHeaderViewDidTapNewPostButton(_ profileHeaderView: ProfileHeaderView)
    
}

// MARK: - ProfileHeaderView class

final class ProfileHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Delegate
    
    weak var delegate: ProfileHeaderViewDelegate?
    
    // MARK: Private Properties
    
    private var profilePictureOrigin = CGPoint()
    private var postsAmount: Int = 0 {
        didSet {
            totalPostsLabel.text = String(postsAmount) + "\n" + "posts".localizedLowercase
        }
    }
    
    // MARK: Subviews
    
    private  lazy var profilePictureView: UIImageView = {
        let profilePictureView = UIImageView(frame: CGRect(x: .zero, y: .zero, width: 104, height: 104))
        
        profilePictureView.clipsToBounds = true
        profilePictureView.contentMode = .scaleAspectFill
        profilePictureView.backgroundColor = Palette.dynamicTextfield
        
        profilePictureView.layer.cornerRadius = profilePictureView.bounds.height / 2
        profilePictureView.layer.borderWidth = 3
        profilePictureView.image = UIImage(named: "ImagePlaceholder")
        profilePictureView.translatesAutoresizingMaskIntoConstraints = false
        
        profilePictureView.isUserInteractionEnabled = true
        
        
        
        return profilePictureView
    }()
    
    private lazy var pictureBackground = UIView(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: UIScreen.main.bounds.width,
                                                              height: UIScreen.main.bounds.height))
    
    private lazy var crossButton: UIButton = {
        let crossButton = UIButton()
        
        crossButton.frame = CGRect(x: UIScreen.main.bounds.width - 48, y: 24, width: 28, height: 28)
        crossButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        crossButton.imageView?.clipsToBounds = true
        crossButton.tintColor = .white
        crossButton.alpha = 0
        
        crossButton.addTarget(self, action: #selector(didTapOnCrossButton(_:)), for: .touchDown)
        
        crossButton.isUserInteractionEnabled = false
        crossButton.isHidden = true
        return crossButton
    }()
    
    private lazy var profileNameLabel: UILabel = {
        let profileNameLabel = UILabel()
        
        profileNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        profileNameLabel.text = "defaultUser"
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return profileNameLabel
    }()
    
    private lazy var profileStatusLabel: UILabel = {
        let profileStatusLabel = UILabel()
        
        profileStatusLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        profileStatusLabel.textColor = .gray
        profileStatusLabel.text = NSLocalizedString("nothingToSee", comment: "")
        profileStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return profileStatusLabel
    }()
    
    private lazy var editProfileButton: CustomButton = {
       
        let buttonAction = { [weak self] in
            guard let self else { return }
            self.delegate?.profileHeaderViewDidTapEditProfileButton(self)
            
        }
        
        let statusButton = CustomButton(title: "editProfile".localized,
                                        backgroundColor: Palette.accentOrange,
                                        titleColor: UIColor.white,
                                        action: buttonAction)
        
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        return statusButton
    }()
    
    private lazy var totalPostsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "\(postsAmount)\n"+"posts".localized.lowercased()
        
        return label
    }()
    
    private lazy var statsStack: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        stackView.addArrangedSubview(totalPostsLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var separatorLine: UIView = {
       let view = UIView()
       
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.layer.borderWidth = 2
        
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var newPostButton: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 68, height: 68))
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "square.and.pencil")
        configuration.title = "post".localized.lowercased()
        configuration.imagePlacement = .top
        configuration.titlePadding = 8
        configuration.imagePadding = 8
        
        button.configuration = configuration
        button.tintColor = Palette.dynamicMonochromeButton
        
        let buttonAction = UIAction { [weak self] _ in
            guard let self else { return }
            self.delegate?.profileHeaderViewDidTapNewPostButton(self)
        }
        button.addAction(buttonAction, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var newPhotoButton: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 68, height: 68))
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "camera.on.rectangle")
        configuration.title = "photo".localized.lowercased()
        configuration.imagePlacement = .top
        configuration.titlePadding = 8
        configuration.imagePadding = 8
        
        button.configuration = configuration
        button.tintColor = Palette.dynamicMonochromeButton
        
        // TODO: to be implemented in future versions
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var publicationButtonsStack: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        stackView.addArrangedSubview(newPostButton)
        stackView.addArrangedSubview(newPhotoButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Private methods
    
    private func tapOnProfilePicture() {
        
        delegate?.isScrollAndSelectionEnabled(false)
        
        profilePictureOrigin = profilePictureView.center
        
        profilePictureView.contentMode = .scaleAspectFit
        profilePictureView.isUserInteractionEnabled = false
        
        pictureBackground.isHidden = false
        
        crossButton.isHidden = false
        crossButton.isUserInteractionEnabled = true
        
        let zoomedBackgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        let scaleX = UIScreen.main.bounds.width / profilePictureView.frame.width
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                
                self.pictureBackground.backgroundColor = zoomedBackgroundColor
                self.profilePictureView.backgroundColor = .none
                self.profilePictureView.layer.cornerRadius = 0
                self.profilePictureView.layer.borderWidth = 0
                self.profilePictureView.center = CGPoint(x: UIScreen.main.bounds.midX,
                                                         y: UIScreen.main.bounds.midY - self.profilePictureOrigin.y)
                self.profilePictureView.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
                self.delegate?.setTabBarColor(.black)
                
            },
            completion: {_ in
                UIView.animate(withDuration: 0.3, animations: {
                    self.crossButton.alpha = 1
                })
            }
        )
    }
    
    private func closeProfilePicture() {
        
        profilePictureView.contentMode = .scaleAspectFill
        
        let closedBackgroundColor = UIColor.black.withAlphaComponent(0)
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            self.profilePictureView.center = self.profilePictureOrigin
            self.profilePictureView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.width / 2
            self.profilePictureView.layer.borderWidth = 3
            self.pictureBackground.backgroundColor = closedBackgroundColor
            self.delegate?.setTabBarColor(Palette.dynamicBars)
            self.crossButton.alpha = 1
            
        }, completion: {_ in
            self.crossButton.isHidden = true
            self.crossButton.isUserInteractionEnabled = false
            self.pictureBackground.isHidden = true
            self.delegate?.isScrollAndSelectionEnabled(true)
            self.profilePictureView.isUserInteractionEnabled = true
            
        })
    }
    
    private func setup() {
    
        pictureBackground.isHidden = true
      
    }
    
    // MARK: Constraints
    
    private func setupSubviews() {
        addSubview(profileNameLabel)
        addSubview(profileStatusLabel)
        addSubview(editProfileButton)
        addSubview(profilePictureView)
        addSubview(pictureBackground)
        addSubview(crossButton)
        addSubview(statsStack)
        addSubview(separatorLine)
        addSubview(publicationButtonsStack)
        
        NSLayoutConstraint.activate([
            profilePictureView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profilePictureView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profilePictureView.widthAnchor.constraint(equalToConstant: profilePictureView.frame.width),
            profilePictureView.heightAnchor.constraint(equalToConstant: profilePictureView.frame.height),
            
            profileNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profileNameLabel.leadingAnchor.constraint(equalTo: profilePictureView.trailingAnchor, constant: 24),
            profileNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            profileStatusLabel.leadingAnchor.constraint(equalTo: profilePictureView.trailingAnchor, constant: 24),
            profileStatusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            profileStatusLabel.centerYAnchor.constraint(equalTo: profilePictureView.centerYAnchor),
            
            editProfileButton.topAnchor.constraint(equalTo: profilePictureView.bottomAnchor, constant: 34),
            editProfileButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            editProfileButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            editProfileButton.heightAnchor.constraint(equalToConstant: 50),
           
            statsStack.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 16),
            statsStack.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor, constant: 16),
            statsStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            statsStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            statsStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            separatorLine.topAnchor.constraint(equalTo: statsStack.bottomAnchor, constant: 16),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            publicationButtonsStack.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 16),
            publicationButtonsStack.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor, constant: 16),
            publicationButtonsStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            publicationButtonsStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            publicationButtonsStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 68),
            
            bottomAnchor.constraint(equalTo: publicationButtonsStack.bottomAnchor, constant: 16)
            
        ])
    }
    
    // MARK: Public methods
    
    func update(with user: User) {
        profileNameLabel.text = user.fullName
        totalPostsLabel.text = "\(postsAmount)\n"+"posts".localized.lowercased()
    }
    
    func update(postsAmount: Int) {
        self.postsAmount = postsAmount
    }
    
    func update(userAvatar: UIImage) {
        self.profilePictureView.image = userAvatar
    }
    
    // MARK: Override init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setup()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  ObjC actions
    
    @objc fileprivate func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc private func didTapOnProfilePicture() {
        
        tapOnProfilePicture()
        
    }
    
    @objc private func didTapOnCrossButton(_ sender: UIButton) {
        
        closeProfilePicture()
        
    }
    
}

// MARK: - TextField delegate extension

extension ProfileHeaderView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        statusField.resignFirstResponder()
        return true
    }
}
