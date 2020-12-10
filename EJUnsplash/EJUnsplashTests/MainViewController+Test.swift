//
//  MainViewController+Test.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/10.
//

import UIKit
@testable import EJUnsplash


extension MainViewController {
    static let storyboardID = "MainViewController"
    
    static func createViewController() -> MainViewController {
        return UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(identifier: storyboardID) as! MainViewController
    }
    
    
    static func createStickyHeaderView() -> StickyHeaderView {
        let viewController = createViewController()
        viewController.loadView()
        return viewController.stickyHeaderView
    }
}
