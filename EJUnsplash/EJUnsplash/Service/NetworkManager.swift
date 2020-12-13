//
//  NetworkManager.swift
//  EJUnsplash
//
//  Created by John on 2020/12/12.
//

import Foundation

protocol INetworkManager {
    func sendRequest(_ request: UnsplashRequest, completionHandler: @escaping (Data?, Error?)->())
    func sendDownloadRequest(url: URL, completionHandler: @escaping (Data?, Error?)->())
}


struct NetworkManager: INetworkManager {
    
    var session: URLSession = URLSession.shared
    
    func sendRequest(_ request: UnsplashRequest, completionHandler: @escaping (Data?, Error?) -> ()) {
        // TODO request가 nil일때 오류 처리 구현해야함
        guard let urlRequest = request.createURLRequest() else { fatalError() }
        let task = session.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                completionHandler(error != nil ? nil : data, error)
            }
        }
        task.resume()
    }
    
    
    func sendDownloadRequest(url: URL, completionHandler: @escaping (Data?, Error?) -> ()) {
        let task = session.dataTask(with: url) { data, response, error in
            completionHandler(data, error)
        }
        task.resume()
    }
    
}
