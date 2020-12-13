//
//  DetailViewModel.swift
//  EJUnsplash
//
//  Created by John on 2020/12/13.
//

import Foundation

protocol IDetailViewModel {
}

class DetailViewModel: IDetailViewModel {
    var url: URL?
    
    init(url: URL?) {
        self.url = url
    }
}
