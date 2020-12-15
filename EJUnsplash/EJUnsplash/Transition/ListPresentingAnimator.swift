//
//  ListPresentingAnimator.swift
//  EJUnsplash
//
//  Created by John on 2020/12/14.
//

import UIKit

class ListPresentingAnimator: NSObject {
    var originalFrame =  CGRect()
    var duration = TimeInterval(0.3)
}


extension ListPresentingAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let finalFrame = toView.frame
        toView.frame = originalFrame
        container.addSubview(toView)
        toView.backgroundColor = UIColor(white: 0, alpha: 0)
        toView.layoutIfNeeded()
        UIView.animate(withDuration: duration) {
            toView.frame = finalFrame
            toView.backgroundColor = UIColor(white: 0, alpha: 1)
            toView.layoutIfNeeded()
        } completion: { success in
            transitionContext.completeTransition(success)
        }
    }
}
