//
//  UnsplashAPI.swift
//  EJUnsplash
//
//  Created by John on 2020/12/12.
//

import Foundation

enum UnsplashAPI: String {
    case list = "/photos"
    case random = "/photos/random"
    case search = "/search/photos"
}


enum UnsplashParameterKey: String {
    case page
    case per_page
}
