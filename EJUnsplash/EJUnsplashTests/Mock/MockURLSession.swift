//
//  MockURLSession.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/13.
//

import Foundation
@testable import EJUnsplash

class MockURLSession: URLSession {
    var wasCalled = ""
    var paramRequest: URLRequest?
    var dataTask: MockURLSessionDataTask?
    
    init(name: String = "") {
        
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        wasCalled += "called \(#function)"
        paramRequest = request
        dataTask =  MockURLSessionDataTask(completionHandler: completionHandler)
        return dataTask!
    }
}
