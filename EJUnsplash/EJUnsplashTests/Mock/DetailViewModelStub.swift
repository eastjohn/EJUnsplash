//
//  DetailViewModelStub.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/14.
//

import UIKit
@testable import EJUnsplash

class DetailViewModelStub: IDetailViewModel {
    var wasCalled = ""
    var completionHandler: ( (UIImage)->() )?
    
    func getName() -> String {
        return ""
    }
    
    func bindPhotoImage(completionHandler: @escaping (UIImage)->()) {
        wasCalled += "called \(#function)"
        self.completionHandler = completionHandler
    }
}
