//
//  UIViewController+TextPicker.swift
//  FileStorageManager
//
//  Created by Ляпин Михаил on 10.06.2023.
//

import Foundation
import UIKit

extension UIViewController {
    func presentTextPicker(title: String, message: String? = nil, completion: @escaping ((_ text: String) -> Void)) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alertController.addTextField()
        
        let actionOk = UIAlertAction(title: "Ok", style: .default) { _ in
            if let text = alertController.textFields?[0].text {
                completion(text)
            }
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(actionCancel)
        alertController.addAction(actionOk)

        
        self.present(alertController, animated: true)
    }
}

