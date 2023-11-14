//
//  FeedTableSectionHeaderView.swift
//  Navigation
//
//  Created by Ляпин Михаил on 13.11.2023.
//

import Foundation
import UIKit

// MARK: - FeedTableSectionHeaderView
final class FeedTableSectionHeaderView: UIView {
    
    // MARK: Subviews
    private lazy var dateLabel: UILabel = {
       let label = UILabel()
        
        label.textColor = UIColor.systemGray4
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.layer.cornerRadius = 12
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.systemGray4.cgColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var leadingSeparator = SeparatorLine(borderWidth: 2, borderColor: UIColor.systemGray4.cgColor)
    private lazy var trailingSeparator = SeparatorLine(borderWidth: 2, borderColor: UIColor.systemGray4.cgColor)
    
    // MARK: Private properties
    
    private var dateFormatter = DateFormatter()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(date: Date) {
        self.init(frame: .zero)
        
        setup()
        setDate(date)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        addSubview(dateLabel)
        addSubview(trailingSeparator)
        addSubview(leadingSeparator)
        
        NSLayoutConstraint.activate([
        
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 24),
            dateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            leadingSeparator.centerYAnchor.constraint(equalTo: centerYAnchor),
            leadingSeparator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            leadingSeparator.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -12),
            leadingSeparator.heightAnchor.constraint(equalToConstant: 2),
            
            trailingSeparator.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingSeparator.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 12),
            trailingSeparator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            trailingSeparator.heightAnchor.constraint(equalToConstant: 2),
            
            heightAnchor.constraint(equalToConstant: 48)
        
        ])
    }
    
    private func setDate(_ date: Date) {
        
        dateFormatter.dateFormat = "dd MMMM"
        
        self.dateLabel.text = dateFormatter.string(for: date)
        
    }
    
    
}

// MARK: - SeparatorLine embedded type

extension FeedTableSectionHeaderView {
    
    final class SeparatorLine: UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        convenience init(borderWidth: CGFloat, borderColor: CGColor) {
            self.init(frame: .zero)
            
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor
            
            translatesAutoresizingMaskIntoConstraints = false

        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    }
    
    
}
