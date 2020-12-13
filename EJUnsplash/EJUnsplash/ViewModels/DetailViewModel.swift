//
//  DetailViewModel.swift
//  EJUnsplash
//
//  Created by John on 2020/12/13.
//

import UIKit

protocol IDetailViewModel {
    func getName() -> String
    func bindPhotoImage(completionHandler: @escaping (UIImage)->())
}


class DetailViewModel: IDetailViewModel {
    var photoInfo: PhotoInfo
    var imageCacheManager: IImageCacheManager = ImageCacheManager.shared
    
    init(photoInfo: PhotoInfo) {
        self.photoInfo = photoInfo
    }
    
    func getName() -> String {
        return photoInfo.name
    }
    
    
    func bindPhotoImage(completionHandler: @escaping (UIImage)->()) {
        imageCacheManager.loadImage(url: photoInfo.url) { image in
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }
    }
}
