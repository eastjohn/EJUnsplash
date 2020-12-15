//
//  PhotoInfo.swift
//  EJUnsplash
//
//  Created by John on 2020/12/11.
//

import UIKit

struct PhotoInfo: Equatable {
    let name: String
    let url: URL?
    let size: CGSize
}


struct PhotoInfoFactory {
    static func createPhotoInfo(jsonDic: [String: Any]) -> PhotoInfo? {
        guard let name = (jsonDic[UnsplashJsonParameterKey.user.rawValue] as? [String: Any])?[UnsplashJsonParameterKey.name.rawValue] as? String else { return nil }
        guard let urlString = (jsonDic[UnsplashJsonParameterKey.urls.rawValue] as? [String: String])?[UnsplashJsonParameterKey.small.rawValue] else { return nil }
        guard let width = jsonDic[UnsplashJsonParameterKey.width.rawValue] as? Int else { return nil }
        guard let height = jsonDic[UnsplashJsonParameterKey.height.rawValue] as? Int else { return nil }
        
        return PhotoInfo(name: name, url: URL(string: urlString), size: CGSize(width: width, height: height))
    }
}
