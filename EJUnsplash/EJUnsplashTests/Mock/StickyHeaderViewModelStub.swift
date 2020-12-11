//
//  StickHeaderViewModelStub.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/11.
//

import UIKit
@testable import EJUnsplash

class StickyHeaderViewModelStub: IStickyHeaderViewModel {
    var completionHandler: ( (UIImage)->() )?
    
    
    func bindBackgroundImage(completionHandler: @escaping (UIImage) -> ()) {
        self.completionHandler = completionHandler
    }
    
    
    func updateImage(_ image: UIImage) {
        completionHandler?(image)
    }
}
