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
}


struct ListViewModel: IListViewModel {
    
    var dataCount: Int {
        return 0
    }
    
    
    func bindPhotoDatas(changedHandler: @escaping (Range<Int>) -> ()) {
        
    }
    
    
    func fetchDatas() {
    }
    
    
    func updatePhotoInfo(for indexPath: IndexPath, updateHandler: (PhotoInfo) -> (), completionLoadedPhotoImageHandler: @escaping (UIImage) -> ()) {
        
    }
    
    
    func prefetchRowsAt(indexPaths: [IndexPath]) {
        
    }
    
    
    func cancelPrefetchingForRowsAt(indexPaths: [IndexPath]) {
        
    }
    
    
    func didEndDisplayingAt(indexPath: IndexPath) {
        
    }
}
