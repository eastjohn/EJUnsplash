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
    
    let imageCache = NSCache<NSURL, UIImage>()
    var networkManager: INetworkManager = NetworkManager()
    
    func loadImage(url: URL?, completionHandler: @escaping (UIImage) -> ()) {
        guard let url = url else { return }
        if let image = imageCache.object(forKey: url as NSURL) {
            completionHandler(image)
        } else {
            networkManager.sendDownloadRequest(url: url) { [weak self] data, error in
                guard let data = data, let image = UIImage(data: data) else { return }
                self?.imageCache.setObject(image, forKey: url as NSURL)
                completionHandler(image)
            }
        }
    }
    
    
}
