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
    
    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet {
            viewModel.bindBackgroundImage { [weak self] in self?.backgroundImageView.image = $0 }
            viewModel.fetchDatas()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.backgroundImage = UIImage()
        }
    }
    
    var viewModel: IStickyHeaderViewModel = StickyHeaderViewModel(service: UnsplashRandomService())
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.alpha = calculateAlphaByHeightRatio()
    }
    
    private func calculateAlphaByHeightRatio() -> CGFloat {
        return (bounds.height - StickyHeaderView.MinHeight) / (StickyHeaderView.MaxHeight - StickyHeaderView.MinHeight)
    }
}
