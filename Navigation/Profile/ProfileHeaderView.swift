//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Ляпин Михаил on 13.02.2023.
//

import UIKit

// MARK: - ProfileHeaderView class

final class ProfileHeaderView: UIView {
    
    // MARK: - Delegate
    
    var delegate: ProfileViewController!
    
    // MARK: - Private properties
    
    private  lazy var profilePictureView: UIImageView = {
        let profilePictureView = UIImageView(frame: CGRect(x: .zero, y: .zero, width: 104, height: 104))
        
        profilePictureView.clipsToBounds = true
        profilePictureView.contentMode = .scaleAspectFill
        profilePictureView.backgroundColor = .white
        
        profilePictureView.layer.cornerRadius = profilePictureView.bounds.height / 2
        profilePictureView.layer.borderColor = UIColor.white.cgColor
        profilePictureView.layer.borderWidth = 3
        profilePictureView.image = UIImage(named: "ImagePlaceholder")
        profilePictureView.translatesAutoresizingMaskIntoConstraints = false
        
        profilePictureView.isUserInteractionEnabled = true
      

        
        return profilePictureView
    }()
    
    private var profilePictureOrigin = CGPoint()
    
    private lazy var pictureBackground = UIView(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: UIScreen.main.bounds.width,
                                                              height: UIScreen.main.bounds.height))
    
    private lazy var crossButton: UIButton = {
        let cross = UIButton()
        
        cross.frame = CGRect(x: UIScreen.main.bounds.width - 48, y: 24, width: 28, height: 28)
        cross.setImage(UIImage(systemName: "xmark"), for: .normal)
        cross.imageView?.clipsToBounds = true
        cross.tintColor = .white
        cross.alpha = 0
        
        cross.isUserInteractionEnabled = false
        cross.isHidden = true
        return cross
    }()
    
    private lazy var profileNameLabel: UILabel = {
        let profileNameLabel = UILabel()
        
        profileNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        profileNameLabel.textColor = .black
        profileNameLabel.text = "defaultUser"
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
    
        return profileNameLabel
    }()
    
    private lazy var profileStatusLabel: UILabel = {
        let profileStatusLabel = UILabel()
        
        profileStatusLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        profileStatusLabel.textColor = .gray
        profileStatusLabel.text = "Nothing to see here yet..."
        profileStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return profileStatusLabel
    }()
    
    private lazy var statusButton: CustomButton = {
        
        let buttonAction = { [weak self] in
            guard let status = self?.profileStatusLabel.text else {
                print("Nothing to see here")
                return
            }
            
            print (status)
        }
        
        let statusButton = CustomButton(title: "Print status", action: buttonAction)
    
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        
        return statusButton
    }()
    

    private lazy var statusField: CustomTextField = {
        let statusField = CustomTextField()

        statusField.layer.borderWidth = 1
        statusField.layer.borderColor = UIColor.black.cgColor
        statusField.layer.cornerRadius = 12
        statusField.layer.backgroundColor = UIColor.white.cgColor

        statusField.placeholder = "What's new?"

        statusField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        statusField.textColor = UIColor.black
        statusField.enablesReturnKeyAutomatically = true
        statusField.returnKeyType = .done
        statusField.delegate = self
        statusField.translatesAutoresizingMaskIntoConstraints = false

        return statusField
    }()
    
    // MARK: - Private methods

    private func tapOnProfilePicture() {
    
        delegate.isScrollAndSelectionEnabled(false)
        
        profilePictureOrigin = profilePictureView.center
        
        profilePictureView.contentMode = .scaleAspectFit
        profilePictureView.isUserInteractionEnabled = false
        
        pictureBackground.isHidden = false
        
        crossButton.isHidden = false
        crossButton.isUserInteractionEnabled = true
        
        let zoomedBackgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        let scaleX = UIScreen.main.bounds.width / profilePictureView.frame.width
        
        UIView.animate(
            withDuration: 0.5,
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
                self.delegate.tabBarController?.tabBar.standardAppearance.backgroundColor = .black

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
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            self.profilePictureView.center = self.profilePictureOrigin
            self.profilePictureView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.width / 2
            self.profilePictureView.layer.borderWidth = 3
            self.pictureBackground.backgroundColor = closedBackgroundColor
            self.delegate.tabBarController?.tabBar.standardAppearance.backgroundColor = .white
            self.crossButton.alpha = 1
            
        }, completion: {_ in
            self.crossButton.isHidden = true
            self.crossButton.isUserInteractionEnabled = false
            self.pictureBackground.isHidden = true
            self.delegate.isScrollAndSelectionEnabled(true)
            self.profilePictureView.isUserInteractionEnabled = true
            
        })
    }
    
    private func setup() {
        
        addSubview(profileNameLabel)
        addSubview(profileStatusLabel)
        
        addSubview(statusButton)
        
        statusField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
        addSubview(statusField)
        
        addSubview(pictureBackground)
        pictureBackground.isHidden = true
            
        addSubview(profilePictureView)

        crossButton.addTarget(self, action: #selector(didTapOnCrossButton(_:)), for: .touchDown)
        addSubview(crossButton)
        
    }
    
    private func setConstraints() {

        NSLayoutConstraint.activate([
            profilePictureView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profilePictureView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profilePictureView.widthAnchor.constraint(equalToConstant: profilePictureView.frame.width),
            profilePictureView.heightAnchor.constraint(equalToConstant: profilePictureView.frame.height),
            
            profileNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profileNameLabel.leadingAnchor.constraint(equalTo: profilePictureView.trailingAnchor, constant: 24),
            profileNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

//            statusButton.topAnchor.constraint(equalTo: profilePictureView.bottomAnchor, constant: 16),
            statusButton.topAnchor.constraint(equalTo: profilePictureView.bottomAnchor, constant: 34),
            statusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            statusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusButton.heightAnchor.constraint(equalToConstant: 50),

            profileStatusLabel.leadingAnchor.constraint(equalTo: profilePictureView.trailingAnchor, constant: 24),
            profileStatusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            profileStatusLabel.bottomAnchor.constraint(equalTo: statusButton.topAnchor, constant: -34),
            profileStatusLabel.centerYAnchor.constraint(equalTo: profilePictureView.centerYAnchor),

            statusField.leadingAnchor.constraint(equalTo: profilePictureView.trailingAnchor, constant: 24),
            statusField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusField.heightAnchor.constraint(equalToConstant: 40),
            statusField.centerYAnchor.constraint(equalTo: profilePictureView.bottomAnchor),
            
            bottomAnchor.constraint(equalTo: statusButton.bottomAnchor, constant: 16)
            
        ])
    }
    
    // MARK: - Public methods
    
    func update(with user: User) {
        profileNameLabel.text = user.fullName
        
        if let status = user.status {
            profileStatusLabel.text = status
        }
        
        if let avatar = user.avatar {
            profilePictureView.image = avatar
        } else {
            profilePictureView.image = UIImage(named: "ImagePlaceholder")
        }
        
        let tapOnProfilePicture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapOnProfilePicture)
        )
        profilePictureView.addGestureRecognizer(tapOnProfilePicture)
        
    }
    
    // MARK: - Override init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setConstraints()
     
    }
    
//
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//
//        setup()
//        setConstraints()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ObjC actions
    
    @objc fileprivate func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc fileprivate func statusTextChanged(_ textField: UITextField) {
        
        statusButton.setTitle("Set status", for: .normal)
        
        statusButton.buttonAction = {[weak self] in
            
            
            self?.profileStatusLabel.text = textField.text
            textField.text = nil
            self?.statusButton.setTitle("Print status", for: .normal)
            
            self?.statusButton.buttonAction = {[weak self] in
                guard let status = self?.profileStatusLabel.text else {
                    print("Nothing to see here")
                    return
                }
                
                print (status)
                
            }
        }
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
        statusField.resignFirstResponder()
        return true
    }
}
