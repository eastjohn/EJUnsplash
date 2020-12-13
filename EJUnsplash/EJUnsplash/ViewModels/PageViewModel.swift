//
//  PageViewModel.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/13.
//

import Foundation

protocol IPageViewModel {
    func setPhotoDatas(_ photoDatas: [PhotoInfo])
    func urlAt(_ index: Int) -> URL?
}


class PageViewModel: IPageViewModel {
    var unsplashService: UnsplashService
    var photoDatas = [PhotoInfo]()
    
    init(service: UnsplashService) {
        unsplashService = service
        unsplashService.addBindingUpdateDatas { [weak self] photoDatas in
            self?.photoDatas.append(contentsOf: photoDatas)
        }
    }
    
    
    deinit {
        unsplashService.removeBindingUpdateDatas()
    }
    
    
    func setPhotoDatas(_ photoDatas: [PhotoInfo]) {
        self.photoDatas = photoDatas
    }
    
    
    func urlAt(_ index: Int) -> URL? {
        guard index >= 0 && index < photoDatas.count else { return nil }
        fetchDatasIfNeeded(index: index)
        return photoDatas[index].url
    }
    
    private func fetchDatasIfNeeded(index: Int) {
        if index > photoDatas.count - Constants.preFetchingCount {
            unsplashService.fetchDatas()
        }
    }
}
