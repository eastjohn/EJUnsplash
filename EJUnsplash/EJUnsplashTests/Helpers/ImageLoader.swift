//
//  ImageLoader.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/13.
//

import UIKit

struct ImageLoader {
    static func loadImage(fileName: String) -> UIImage {
        let data = DataLoader.load(fileName: fileName)
        return UIImage(data: data)!
    }
}
