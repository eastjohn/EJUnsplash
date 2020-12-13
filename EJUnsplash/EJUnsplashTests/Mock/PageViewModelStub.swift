//
//  PageViewModelStub.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/13.
//

import Foundation
@testable import EJUnsplash

class PageViewModelStub: IPageViewModel {
    var photoDatas = [PhotoInfo]()
    
    func setPhotoDatas(_ photoDatas: [PhotoInfo]) {
        self.photoDatas = photoDatas
    }
    
    
    func urlAt(_ index: Int) -> URL? {
        guard index >= 0 && index < photoDatas.count else { return nil }
        return photoDatas[index].url
    }
}
