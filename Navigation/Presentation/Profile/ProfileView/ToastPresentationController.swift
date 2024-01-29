//
//  ToastPresentationController.swift
//  Navigation
//
//  Created by Ляпин Михаил on 18.05.2023.
//

import Foundation
import UIKit

class ToastPresentationController: UIPresentationController {
    
    // MARK: Override properties
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView,
              let presentedView = presentedView else { return .zero }
        
        let inset: CGFloat = 16
        
        // Make sure to account for the safe area insets
        let safeAreaFrame = containerView.bounds
            .inset(by: containerView.safeAreaInsets)
        
        let targetWidth = safeAreaFrame.width - 2 * inset
        let fittingSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )
        let targetHeight = presentedView.systemLayoutSizeFitting(
            fittingSize, withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow).height
        
        var frame = safeAreaFrame
        frame.origin.x += inset
        frame.origin.y += frame.size.height - targetHeight - inset
        frame.size.width = targetWidth
        frame.size.height = targetHeight
        return frame
    }
    
    // MARK: Override methods
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        presentedView?.layer.cornerRadius = 12
        
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        containerView?.isUserInteractionEnabled = false
    }
    
    
}
