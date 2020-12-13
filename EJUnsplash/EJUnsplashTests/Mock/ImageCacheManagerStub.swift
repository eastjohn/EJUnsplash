//
//  ImageCacheManagerStub.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/13.
//

import UIKit
@testable import EJUnsplash

class ImageCacheManagerStub: IImageCacheManager {
    var wasCalled = ""
    var paramURL: URL?
    var completionHandler: ( (UIImage) -> () )?
    
    
    func loadImage(url: URL?, completionHandler: @escaping (UIImage) -> ()) {
        wasCalled += "called \(#function)"
        paramURL = url
        self.completionHandler = completionHandler
    }
}
