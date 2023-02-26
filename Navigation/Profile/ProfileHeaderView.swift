//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Ляпин Михаил on 13.02.2023.
//

import UIKit

class ProfileHeaderView: UIView {
    
    private  lazy var
profilePictureView: UIImageView = {
        let profilePictureView = UIImageView(frame: CGRect(x: .zero, y: .zero, width: 104, height: 104))
        
        profilePictureView.clipsToBounds = true
        profilePictureView.contentMode = .scaleAspectFill
        profilePictureView.backgroundColor = .white
        
        profilePictureView.layer.cornerRadius = profilePictureView.bounds.height / 2
        profilePictureView.layer.borderColor = UIColor.white.cgColor
        profilePictureView.layer.borderWidth = 3
        profilePictureView.image = UIImage(named: "DarthVader")
        profilePictureView.translatesAutoresizingMaskIntoConstraints = false
        
        return profilePictureView
    }()
    
    private lazy var profileNameLabel: UILabel = {
        let profileNameLabel = UILabel()
        
        profileNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        profileNameLabel.textColor = .black
        profileNameLabel.text = "Darth Vader"
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
    
        return profileNameLabel
    }()
    
    private lazy var profileStatusLabel: UILabel = {
        let profileStatusLabel = UILabel()
        
        profileStatusLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        profileStatusLabel.textColor = .gray
        profileStatusLabel.text = "Join the dark side!.."
        profileStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return profileStatusLabel
    }()
    
    private lazy var statusButton: CustomButton = {
        let statusButton = CustomButton(custom: true)
        
        statusButton.backgroundColor = .white
        statusButton.clipsToBounds = true
        statusButton.titleLabel?.textColor = .white
        statusButton.layer.cornerRadius = 4
        statusButton.layer.backgroundColor = statusButton.color?.cgColor
        statusButton.layer.masksToBounds = false
        statusButton.layer.shadowOpacity = 0.7
        statusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        statusButton.layer.shadowRadius = 4
        statusButton.layer.shadowColor = UIColor.black.cgColor
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

    private var statusText: String?

    
    private func setup() {
        
        addSubview(profilePictureView)
        addSubview(profileNameLabel)
        addSubview(profileStatusLabel)
        
        
        statusField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
        addSubview(statusField)

        statusButton.addTarget(self, action: #selector(buttonHandler(_:)), for: .touchUpInside)
        addSubview(statusButton)
        
    }
    
    private func setConstraints() {
        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            profilePictureView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            profilePictureView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            profilePictureView.widthAnchor.constraint(equalToConstant: profilePictureView.frame.width),
            profilePictureView.heightAnchor.constraint(equalToConstant: profilePictureView.frame.height),
            
            profileNameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            profileNameLabel.leadingAnchor.constraint(equalTo: profilePictureView.trailingAnchor, constant: 24),
            profileNameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),

//            statusButton.topAnchor.constraint(equalTo: profilePictureView.bottomAnchor, constant: 16),
            statusButton.topAnchor.constraint(equalTo: profilePictureView.bottomAnchor, constant: 34),
            statusButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            statusButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            statusButton.heightAnchor.constraint(equalToConstant: 50),
            
            profileStatusLabel.leadingAnchor.constraint(equalTo: profilePictureView.trailingAnchor, constant: 24),
            profileStatusLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
//            profileStatusLabel.bottomAnchor.constraint(equalTo: statusButton.topAnchor, constant: -34),
            profileStatusLabel.centerYAnchor.constraint(equalTo: profilePictureView.centerYAnchor),

            statusField.leadingAnchor.constraint(equalTo: profilePictureView.trailingAnchor, constant: 24),
            statusField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            statusField.heightAnchor.constraint(equalToConstant: 40),
            statusField.centerYAnchor.constraint(equalTo: profilePictureView.bottomAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setConstraints()
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc fileprivate func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc fileprivate func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text
        statusButton.buttonAction = .setStatus
    }

    @objc func buttonHandler(_ sender: CustomButton) {
        switch sender.buttonAction {
        case .printStatus:
            printStatus(sender)
        case .setStatus:
            setStatus(sender)
            
        default:
            return
        }
        dismissKeyboard()
    }

    @objc fileprivate func printStatus(_ sender: CustomButton) {
        print (self.profileStatusLabel.text ?? "no status")
    }

    @objc fileprivate func setStatus(_ sender: CustomButton) {

        profileStatusLabel.text = statusText
        statusField.text = nil
        sender.buttonAction = .printStatus

    }

}

extension ProfileHeaderView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        statusField.resignFirstResponder()
        return true
    }
}
