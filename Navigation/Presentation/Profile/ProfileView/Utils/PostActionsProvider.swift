//
//  PostActionsProvider.swift
//  Navigation
//
//  Created by Ляпин Михаил on 27.01.2024.
//

import UIKit
import StorageService

final class PostActionsProvider: ActionsProviderProtocol {
    
    // MARK: Public properties 
    
    lazy var actions: [ActionItem] = [sharePost, deletePost]
    
    // MARK: Private propertis
    
    private lazy var sharePost = ActionItem(title: "share".localized,
                                            type: .normal) {
        return 
    }
    
    private lazy var deletePost = ActionItem(title: "delete".localized,
                                             type: .destructive) {
        self.viewController.presentedViewController?.dismiss(animated: true)
        self.viewController.presentAlert(message: "sureToDelete".localized,
                          title: "deletePost".localized,
                          actionTitle: "delete".localized,
                          actionStyle: .destructive,
                          feedBackType: .warning,
                          addCancelAction: true) { [weak self] in
            guard let self else { return }
            self.viewModel.updateState(withInput: .deletePost(self.post))
        }
    }
    
    private let viewController: UIViewController
    private let viewModel: ProfileViewModelProtocol
    private let post: Post
    
    init(viewController: UIViewController, viewModel: ProfileViewModelProtocol, post: Post) {
        self.viewController = viewController
        self.viewModel = viewModel
        self.post = post
    }
}
