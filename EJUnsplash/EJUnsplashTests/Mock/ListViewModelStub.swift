//
//  ListViewModelStub.swift
//  EJUnsplashTests
//
//  Created by 김요한 on 2020/12/11.
//

import UIKit
@testable import EJUnsplash

class ListViewModelStub: IListViewModel {
    var wasCalled = ""
    var dataCount = 10
    var paramIndexPath: IndexPath!
    var paramIndexPaths = [IndexPath]()
    var photoInfo = PhotoInfo(name: "testName", url: URL(string: "http://test.com"))
    var photoImage = UIImage()
    var chagedHandler: ( (Range<Int>)->() )?
    
    
    func fetchDatas() {
        wasCalled += "called \(#function)"
    }
    
    
    func updatePhotoInfo(for indexPath: IndexPath, updateHandler: (PhotoInfo) -> (), completionLoadedPhotoImageHandler: @escaping (UIImage) -> ()) {
        updateHandler(photoInfo)
        completionLoadedPhotoImageHandler(photoImage)
        wasCalled += "called \(#function)"
        paramIndexPath = indexPath
    }
    
    
    func bindPhotoDatas(changedHandler: @escaping (Range<Int>) -> ()) {
        wasCalled += "called \(#function)"
        self.chagedHandler = changedHandler
    }
    
    
    func prefetchRowsAt(indexPaths: [IndexPath]) {
        wasCalled += "called \(#function)"
        paramIndexPaths = indexPaths
    }
    
    
    func cancelPrefetchingForRowsAt(indexPaths: [IndexPath]) {
        wasCalled += "called \(#function)"
        paramIndexPaths = indexPaths
    }
    
    
    func didEndDisplayingAt(indexPath: IndexPath) {
        wasCalled += "called \(#function)"
        paramIndexPath = indexPath
    }
}
