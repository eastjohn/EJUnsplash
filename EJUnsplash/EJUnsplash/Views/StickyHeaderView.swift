//
//  StickyHeaderView.swift
//  EJUnsplash
//
//  Created by John on 2020/12/10.
//

import UIKit

class StickyHeaderView: UIView {
    static let MaxHeight = CGFloat(300)
    static let MinHeight = CGFloat(90)
    
    @IBOutlet var backgroundImageView: UIImageView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.alpha = (bounds.height - StickyHeaderView.MinHeight) / (StickyHeaderView.MaxHeight - StickyHeaderView.MinHeight)
    }
}
