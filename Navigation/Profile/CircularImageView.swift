//
//  CircularImageView.swift
//  Navigation
//
//  Created by Ляпин Михаил on 17.02.2023.
//

import UIKit

final class CircularImageView: UIImageView {
   
    override func layoutSubviews() {
        
        clipsToBounds = true
        contentMode = .scaleAspectFill
        backgroundColor = .white
        
        layer.cornerRadius = bounds.height / 2
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 3
        
    }
    
    init(radius: CGFloat) {
        let frame = CGRect(x: .zero, y: .zero, width: radius, height: radius)
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
