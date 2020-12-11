//
//  StickyHeaderViewModel.swift
//  EJUnsplash
//
//  Created by John on 2020/12/11.
//

import UIKit


protocol IStickyHeaderViewModel {
    mutating func bindBackgroundImage(completionHandler: @escaping (UIImage)->())
}


struct StickyHeaderViewModel : IStickyHeaderViewModel {
    func bindBackgroundImage(completionHandler: (UIImage) -> ()) {
        
    }
    
}
