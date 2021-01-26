//
//  UnsplashServiceStub.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/11.
//

import Foundation
@testable import EJUnsplash

class UnsplashServiceStub: UnsplashService {
    var wasCalled = ""
    var updateHandler: ( (Result<[PhotoInfo], Error>)->() )?
    
    func addBindingUpdateDatas(updateHandler: @escaping (Result<[PhotoInfo], Error>) -> ()) {
        wasCalled += "called \(#function)"
        self.updateHandler = updateHandler
    }
    
    func removeBindingUpdateDatas() {
        wasCalled += "called \(#function)"
    }
    
    func fetchDatas() {
        wasCalled += "called \(#function)"
    }
    
    func fetchDatas(query: String) {
        wasCalled += "called \(#function)"
    }
}
