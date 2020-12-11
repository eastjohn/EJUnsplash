//
//  UICreator.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/11.
//

import UIKit
@testable import EJUnsplash

struct UICreator {
    static let storyboardID = "MainViewController"
    
    static func createMainViewController() -> MainViewController {
        return UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(identifier: storyboardID) as! MainViewController
    }
    
    
    static func createStickyHeaderView() -> StickyHeaderView {
        let viewController = createMainViewController()
        viewController.loadView()
        return viewController.stickyHeaderView
    }
    
    
    static func createListCell() -> ListViewCell {
        let viewController = createMainViewController()
        viewController.loadView()
        return viewController.tableView.dequeueReusableCell(withIdentifier: ListViewCell.Identifier) as! ListViewCell
    }
}

