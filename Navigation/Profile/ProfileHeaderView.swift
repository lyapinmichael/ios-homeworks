//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Ляпин Михаил on 13.02.2023.
//

import UIKit

class ProfileHeaderView: UIView {
    private var profilePictureView: CircularImageView?
    private var profileNameLabel: UILabel?
    private var profileStatusLabel: UILabel?
    private var statusButton: CustomButton?
    
    private var statusField: UITextField?
    private var statusText: String?
    
    
    var profilePicture: UIImage? {
        get { return profilePictureView?.image }
        set { profilePictureView?.image = newValue }
    }
    
    var profileName: String? {
        get { return profileNameLabel?.text }
        set { profileNameLabel?.text = newValue }
    }
    
    var status: String? {
        get { return profileStatusLabel?.text }
        set { profileStatusLabel?.text = newValue }
    }
    
    private func setup() {
        profilePictureView = CircularImageView(radius: 104)
        addSubview(profilePictureView!)
        
        profileNameLabel = UILabel()
        profileNameLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        profileNameLabel?.textColor = .black
        addSubview(profileNameLabel!)
        
        profileStatusLabel = UILabel()
        profileStatusLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        profileStatusLabel?.textColor = .gray
        addSubview(profileStatusLabel!)
        
        statusButton = CustomButton(custom: true)
        statusButton?.addTarget(self, action: #selector(buttonHandler(_:)), for: .touchUpInside)
        addSubview(statusButton!)
        
        statusField = StatusTextField()
        statusField?.delegate = (statusField! as! any UITextFieldDelegate)
        statusField?.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
        statusField?.placeholder = "What's new?"
        addSubview(statusField!)
        
        
    }
    
    private func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        profilePictureView!.translatesAutoresizingMaskIntoConstraints = false
        profileNameLabel!.translatesAutoresizingMaskIntoConstraints = false
        profileStatusLabel!.translatesAutoresizingMaskIntoConstraints = false
        statusButton!.translatesAutoresizingMaskIntoConstraints = false
        statusField!.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profilePictureView!.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            profilePictureView!.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            profilePictureView!.widthAnchor.constraint(equalToConstant: profilePictureView!.frame.width),
            profilePictureView!.heightAnchor.constraint(equalToConstant: profilePictureView!.frame.height),
            
            profileNameLabel!.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            profileNameLabel!.leadingAnchor.constraint(equalTo: profilePictureView!.trailingAnchor, constant: 24),
            profileNameLabel!.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            profileStatusLabel!.leadingAnchor.constraint(equalTo: profilePictureView!.trailingAnchor, constant: 24),
            profileStatusLabel!.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            profileStatusLabel!.centerYAnchor.constraint(equalTo: profilePictureView!.centerYAnchor),
            
            statusButton!.topAnchor.constraint(equalTo: profilePictureView!.bottomAnchor, constant: 34), //set to fit statusField
            statusButton!.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            statusButton!.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            statusButton!.heightAnchor.constraint(equalToConstant: 50),
            
            profileStatusLabel!.leadingAnchor.constraint(equalTo: profilePictureView!.trailingAnchor, constant: 24),
            profileStatusLabel!.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            profileStatusLabel!.bottomAnchor.constraint(equalTo: statusButton!.topAnchor, constant: -34),
            
            statusField!.leadingAnchor.constraint(equalTo: profilePictureView!.trailingAnchor, constant: 24),
            statusField!.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            statusField!.heightAnchor.constraint(equalToConstant: 40),
            statusField!.centerYAnchor.constraint(equalTo: profilePictureView!.bottomAnchor)
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
        statusButton?.setTitle("Set status", for: .normal)
        statusButton?.buttonAction = .setStatus
    }
    
    @objc func buttonHandler(_ sender: CustomButton) {
        switch sender.buttonAction {
        case .printStatus:
            printStatus(sender)
        case .setStatus:
            setStatus(sender)
        case .none:
            return
        }
    }
    
    @objc fileprivate func printStatus(_ sender: CustomButton) {
        print (self.status ?? "no status")
    }
    
    @objc fileprivate func setStatus(_ sender: CustomButton) {
        status = statusText
        statusField?.endEditing(true)
        statusField?.text = nil
        sender.buttonAction = .printStatus

    }
    
}
