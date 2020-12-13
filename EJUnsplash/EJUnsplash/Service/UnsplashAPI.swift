//
//  UnsplashAPI.swift
//  EJUnsplash
//
//  Created by John on 2020/12/12.
//

import Foundation

enum UnsplashAPI: String {
    static let baseURL = "https://api.unsplash.com"
    
    case list = "/photos"
    case random = "/photos/random"
    case search = "/search/photos"
    
    func URLPath() -> String {
        return UnsplashAPI.baseURL + self.rawValue
    }
}


enum UnsplashParameterKey: String {
    case page
    case per_page
    case count
    case query
}


enum UnsplashAccessKey {
    static let key = "XHNGmQXAeut64ask1a4EvAQhAg-OrlMoRu982Dt2aws"
}
