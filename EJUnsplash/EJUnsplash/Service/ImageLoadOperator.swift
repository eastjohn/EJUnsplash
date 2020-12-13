//
//  ImageLoadOperator.swift
//  EJUnsplash
//
//  Created by John on 2020/12/12.
//

import UIKit

class ImageLoadOperator: Operation {
    var imageCacheManager: IImageCacheManager = ImageCacheManager.shared
    
    var photoImage: UIImage?
    var url: URL?
    var completionHandler: ( (UIImage)->() )?
    
    
    init(url: URL?, completionHandler: @escaping (UIImage)->()) {
        self.url = url
        self.completionHandler = completionHandler
    }
    
    override func main() {
        guard !isCancelled else { return }
        
        imageCacheManager.loadImage(url: url) { [weak self] image in
            DispatchQueue.main.async {
                guard let self = self, !self.isCancelled else { return }
                self.completionHandler?(image)
            }
        }
    }
}
