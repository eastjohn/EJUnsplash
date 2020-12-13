//
//  UnsplashRequest.swift
//  EJUnsplash
//
//  Created by John on 2020/12/12.
//

import Foundation


struct UnsplashRequest: Equatable {
    let api: UnsplashAPI
    let parameters: [UnsplashParameterKey: String]
    
    
    func createURLRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: api.URLPath()) else { return nil }
        urlComponents.queryItems = parameters.map {
            URLQueryItem(name: $0.key.rawValue, value: $0.value)
        }
        guard let url = urlComponents.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = ["Authorization": "Client-ID \(UnsplashAccessKey.key)"]
        return urlRequest
    }
}

