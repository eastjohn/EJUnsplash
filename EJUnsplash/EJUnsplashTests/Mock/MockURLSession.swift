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
    var paramURL: URL?
    var dataTask: MockURLSessionDataTask?
    
    init(name: String = "") {
        
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        wasCalled += "called \(#function)"
        paramRequest = request
        dataTask =  MockURLSessionDataTask(completionHandler: completionHandler)
        return dataTask!
    }
    
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        wasCalled += "called \(#function)"
        paramURL = url
        dataTask =  MockURLSessionDataTask(completionHandler: completionHandler)
        return dataTask!
    }
}
