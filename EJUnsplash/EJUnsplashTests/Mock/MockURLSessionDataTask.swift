//
//  MockURLDataTask.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/13.
//

import Foundation


class MockURLSessionDataTask: URLSessionDataTask {
    var wasCalled = ""
    var completionHandler: (Data?, URLResponse?, Error?) -> ()
    
    init(completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        self.completionHandler = completionHandler
    }
    
    
    override func resume() {
        wasCalled += "called \(#function)"
    }
}
