//
//  ListViewModel.swift
//  EJUnsplash
//
//  Created by John on 2020/12/11.
//

import UIKit


protocol IListViewModel {
    var dataCount: Int { get }
    
    func bindPhotoDatas(changedHandler: @escaping (Range<Int>)->())
    func fetchDatas()
    func updatePhotoInfo(for indexPath: IndexPath, updateHandler: (PhotoInfo)->(), completionLoadedPhotoImageHandler: @escaping (UIImage)->() )
    
    func prefetchRowsAt(indexPaths: [IndexPath])
    func cancelPrefetchingForRowsAt(indexPaths: [IndexPath])
    func didEndDisplayingAt(indexPath: IndexPath)
    func photoImageSizeForRowAt(indexPath: IndexPath) -> CGSize
}

protocol ISearchViewModel: IListViewModel {
    func fetchDatas(query: String)
}


class ListViewModel: IListViewModel {
    
    var unsplashService: UnsplashService
    
    var photoDatas = [PhotoInfo]()
    var dataCount: Int {
        return photoDatas.count
    }
    
    var updatePhotoDatasHandler: ( (Range<Int>)->() )?
    var imageLoadOperatorDic = [IndexPath: ImageLoadOperator]()
    var imageLoadOperationQueue = OperationQueue()
    
    init(service: UnsplashService) {
        unsplashService = service
        unsplashService.addBindingUpdateDatas { [weak self] photoInfos in
            self?.receivePhotoDatas(photoInfos: photoInfos)
        }
    }
    
    
    func receivePhotoDatas(photoInfos: [PhotoInfo]) {
        let startIndex = photoDatas.count
        photoDatas.append(contentsOf: photoInfos)
        updatePhotoDatasHandler?(startIndex..<(photoInfos.count + startIndex))
    }
    
    
    func bindPhotoDatas(changedHandler: @escaping (Range<Int>) -> ()) {
        updatePhotoDatasHandler = changedHandler
    }
    
    
    func fetchDatas() {
        unsplashService.fetchDatas()
    }
    
    
    func updatePhotoInfo(for indexPath: IndexPath, updateHandler: (PhotoInfo) -> (), completionLoadedPhotoImageHandler: @escaping (UIImage) -> ()) {
        updateHandler(photoDatas[indexPath.row])
        
        if let imageLoadOperator = imageLoadOperatorDic[indexPath],
           let photoImage = imageLoadOperator.photoImage {
            completionLoadedPhotoImageHandler(photoImage)
        } else {
            let imageLoadOperator = ImageLoadOperator(url: photoDatas[indexPath.row].url, completionHandler: completionLoadedPhotoImageHandler)
            imageLoadOperationQueue.addOperation(imageLoadOperator)
            imageLoadOperatorDic[indexPath] = imageLoadOperator
        }
    }
    
    
    func prefetchRowsAt(indexPaths: [IndexPath]) {
        fetchDatasIfNeeded(indexPaths: indexPaths)
        
        indexPaths.forEach {
            registerImageLoadOperatorIfNeeded(indexPath: $0)
        }
    }
    
    
    private func fetchDatasIfNeeded(indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.row >= photoDatas.count - Constants.preFetchingCount }) {
            unsplashService.fetchDatas()
        }
    }
    
    
    private func registerImageLoadOperatorIfNeeded(indexPath: IndexPath) {
        guard indexPath.row < photoDatas.count else { return }
        if let _ = imageLoadOperatorDic[indexPath] { return }
        
        let imageOperator = ImageLoadOperator(url: photoDatas[indexPath.row].url, completionHandler: {_ in})
        imageLoadOperatorDic[indexPath] = imageOperator
        imageLoadOperationQueue.addOperation(imageOperator)
    }
    
    
    func cancelPrefetchingForRowsAt(indexPaths: [IndexPath]) {
        indexPaths.forEach {
            cancelAndRemoveImageLoadOperator(indexPath: $0)
        }
    }
    
    
    func didEndDisplayingAt(indexPath: IndexPath) {
        cancelAndRemoveImageLoadOperator(indexPath: indexPath)
    }
    
    
    private func cancelAndRemoveImageLoadOperator(indexPath: IndexPath) {
        guard let imageLoadOperator = imageLoadOperatorDic[indexPath] else { return }
        imageLoadOperator.cancel()
        imageLoadOperatorDic.removeValue(forKey: indexPath)
    }
    
    
    func photoImageSizeForRowAt(indexPath: IndexPath) -> CGSize {
        return photoDatas[indexPath.row].size
    }
}


extension ListViewModel: ISearchViewModel {
    func fetchDatas(query: String) {
        photoDatas.removeAll()
        unsplashService.fetchDatas(query: query)
    }
}
