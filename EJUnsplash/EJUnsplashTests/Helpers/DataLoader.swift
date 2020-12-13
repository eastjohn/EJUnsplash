//
//  DataLoader.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/13.
//

import Foundation

class DataLoader {
    static func load(fileName: String) -> Data {
        let path = (Bundle(for: DataLoader.self).resourcePath! as NSString).appendingPathComponent(fileName)
        return try! Data(contentsOf: URL(fileURLWithPath: path))
    }
}
