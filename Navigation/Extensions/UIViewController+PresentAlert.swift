//
//  UIViewController+PresentAlert.swift
//  Navigation
//
//  Created by Ляпин Михаил on 07.06.2023.
//

import UIKit

extension UIViewController {
    
    /// Method used to presend alert which shows some infromation and can take optional no handlers
    func presentAlert(message: String, title: String? = nil, actionTitle: String? = nil, feedBackType: UINotificationFeedbackGenerator.FeedbackType? = nil, addCancelAction: Bool = false, completionHandler:(() -> Void)? = nil) {
        
        
    
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let primaryAction = UIAlertAction(title: actionTitle ?? "close".localized,
                                          style: .default) { action in
            guard let completionHandler else { return }
            completionHandler()
        }
        
        
        
        alert.addAction(primaryAction)
        
        if addCancelAction {
            let cancelAction = UIAlertAction(title: "close".localized, style: .cancel)
            alert.addAction(cancelAction)
        }
        
        
        var notificationFeedbackGenerator: UINotificationFeedbackGenerator?
        if let feedBackType {
            notificationFeedbackGenerator = UINotificationFeedbackGenerator()
            notificationFeedbackGenerator?.prepare()
            notificationFeedbackGenerator?.notificationOccurred(feedBackType)
        }
        
        self.present(alert, animated: true)
    
    }
}
