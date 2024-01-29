//
//  AvatarActions.swift
//  Navigation
//
//  Created by Ляпин Михаил on 26.01.2024.
//

import UIKit

final class  AvatarActionsProvider: ActionsProviderProtocol {
    
    // MARK: Public properties
    
    lazy var actions: [ActionItem] = [] 
    
    // MARK: Private properties
    
    private lazy var deleteAvatar = ActionItem(title: "delete".localized,
                                       type: .destructive) {
        self.viewModel.updateState(withInput: .didTapDeleteAvatarButton)
    }
    
    private lazy var viewAvatar = ActionItem(title: "viewImage".localized,
                                     type: .normal) {
        let avatarDimmingViewController: DimmingViewController = ImageDimmingViewController(image: self.avatar)
        avatarDimmingViewController.present(on: self.presentingViewController)
    }
    
    private lazy var changeAvatar = ActionItem(title: "changeImage".localized,
                                       type: .normal) {
        self.viewModel.updateState(withInput: .didTapChangeAvatarButton)
    }
    
    private let presentingViewController: UIViewController
    private let avatar: UIImage
    private let viewModel: ProfileViewModelProtocol
    
    // MARK: Init
    
    init(presentingViewController: UIViewController, hasAvatar: Bool, avatar: UIImage, viewModel: ProfileViewModelProtocol) {
        self.presentingViewController = presentingViewController
        self.avatar = avatar
        self.viewModel = viewModel
        if hasAvatar {
            actions = [viewAvatar, changeAvatar, deleteAvatar]
        } else {
            actions = [changeAvatar, deleteAvatar]
        }
    }
    
}
