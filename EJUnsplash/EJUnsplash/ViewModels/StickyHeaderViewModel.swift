//
//  StickyHeaderViewModel.swift
//  EJUnsplash
//
//  Created by John on 2020/12/11.
//

import UIKit


protocol IStickyHeaderViewModel {
    func bindBackgroundImage(completionHandler: @escaping (UIImage)->())
}


class StickyHeaderViewModel : IStickyHeaderViewModel {
    var unsplashService: UnsplashService = UnsplashRandomService() {
        didSet {
            unsplashService.addBindingUpdateDatas { [weak self] photoInfos in
                self?.photoDatas = photoInfos
            }
        }
    }
    var imageCacheManager: IImageCacheManager = ImageCacheManager.shared
    var photoDatas = [PhotoInfo]() {
        didSet {
            guard photoDatas.count > 0 else { return }
            loadImage(index: 0)
        }
    }
    var updateHandler: ( (UIImage)->() )?
    var timeInterval = TimeInterval(3)
    
    
    func bindBackgroundImage(completionHandler: @escaping (UIImage) -> ()) {
        updateHandler = completionHandler
    }
    
    
    func loadImage(index: Int) {
        imageCacheManager.loadImage(url: photoDatas[index].url) { image in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateHandler?(image)
                let photoDataCount = self.photoDatas.count
                DispatchQueue.global().asyncAfter(deadline: .now() + self.timeInterval) { [weak self] in
                    self?.loadImage(index: (index + 1) % photoDataCount)
                }
            }
        }
    }
    
}
