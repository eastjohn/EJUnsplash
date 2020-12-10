//
//  StickyHeaderView.swift
//  EJUnsplash
//
//  Created by John on 2020/12/10.
//

import UIKit

class StickyHeaderView: UIView {
    static let MaxHeight = CGFloat(300)
    static let MinHeight = CGFloat(96)
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var searchBar: UISearchBar! {
        didSet {
            searchBar.backgroundImage = UIImage()
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.alpha = (bounds.height - StickyHeaderView.MinHeight) / (StickyHeaderView.MaxHeight - StickyHeaderView.MinHeight)
    }
}
