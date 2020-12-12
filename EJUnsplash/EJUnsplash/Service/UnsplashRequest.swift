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
}


//        let dic = ["page":"1", "per_page": "10"]
//        var urlComponent = URLComponents(string: "http://test.com")
//        urlComponent?.queryItems = dic.map { URLQueryItem(name: $0.key, value: $0.value)}
//
//        print(urlComponent?.url)
