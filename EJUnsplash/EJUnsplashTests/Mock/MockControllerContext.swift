//
//  MockControllerContext.swift
//  EJUnsplashTests
//
//  Created by 김요한 on 2020/12/14.
//

import UIKit
import XCTest

class MockControllerContext: NSObject, UIViewControllerContextTransitioning {
    var expectation: XCTestExpectation?
    let toView = MockView(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
    
    var containerView = UIView()
    var isAnimated = false
    var isInteractive = false
    var transitionWasCancelled = false
    var presentationStyle: UIModalPresentationStyle = .fullScreen
    
    func updateInteractiveTransition(_ percentComplete: CGFloat) {
        
    }
    
    func finishInteractiveTransition() {
        
    }
    
    func cancelInteractiveTransition() {
        
    }
    
    func pauseInteractiveTransition() {
        
    }
    
    func completeTransition(_ didComplete: Bool) {
        expectation?.fulfill()
    }
    
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return nil
    }
    
    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        if key == .to {
            return toView
        }
        return nil
    }
    
    var targetTransform: CGAffineTransform = .identity
    
    func initialFrame(for vc: UIViewController) -> CGRect {
        return CGRect()
    }
    
    func finalFrame(for vc: UIViewController) -> CGRect {
        return CGRect()
    }
    
    
    
}


extension MockControllerContext {
    class MockView: UIView {
        var wasCalled = ""
        var completionHandler: ( ()->() )?
        
        override func layoutIfNeeded() {
            wasCalled += "called \(#function)"
            completionHandler?()
        }
    }
}
