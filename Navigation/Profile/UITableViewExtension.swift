//
//  UITableViewExtension.swift
//  Navigation
//
//  Created by Ляпин Михаил on 02.03.2023.
//

import UIKit

extension UITableView {
    
    func setAndLayout(headerView: UIView) {
        
        tableHeaderView = headerView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalTo: widthAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 220)
        
        ])

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        headerView.frame.size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
