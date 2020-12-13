//
//  ImageCacheManager.swift
//  EJUnsplash
//
//  Created by John on 2020/12/13.
//

import UIKit

protocol IImageCacheManager: class {
    func loadImage(url: URL?, completionHandler: @escaping (UIImage)->())
}


class ImageCacheManager: IImageCacheManager {
    static let shared = ImageCacheManager()
    
    func loadImage(url: URL?, completionHandler: @escaping (UIImage) -> ()) {
        
    }
    
    
}
