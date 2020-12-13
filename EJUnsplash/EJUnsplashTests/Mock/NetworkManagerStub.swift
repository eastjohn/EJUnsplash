//
//  NetworkManagerStub.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/12.
//

import Foundation
@testable import EJUnsplash

class NetworkManagerStub: INetworkManager {
    var wasCalled = ""
    var paramRequest: UnsplashRequest?
    var completionHandler: ( (Data?, Error?) -> () )?
    var paramURL: URL?
    
    
    func sendRequest(_ request: UnsplashRequest, completionHandler: @escaping (Data?, Error?) -> ()) {
        wasCalled += "called \(#function)"
        paramRequest = request
        self.completionHandler = completionHandler
    }
    
    
    func sendDownloadRequest(url: URL, completionHandler: @escaping (Data?, Error?) -> ()) {
        wasCalled += "called \(#function)"
        paramURL = url
        self.completionHandler = completionHandler
    }
}
