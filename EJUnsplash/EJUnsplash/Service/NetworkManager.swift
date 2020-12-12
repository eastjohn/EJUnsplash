//
//  NetworkManager.swift
//  EJUnsplash
//
//  Created by John on 2020/12/12.
//

import Foundation

protocol INetworkManager {
    func sendRequest(_ request: UnsplashRequest, completionHandler: @escaping (Data?, Error?)->())
}


struct NetworkManager: INetworkManager {
    func sendRequest(_ request: UnsplashRequest, completionHandler: @escaping (Data?, Error?) -> ()) {
        
    }
    
}
