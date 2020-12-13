//
//  JsonDataCreator.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/12.
//

import Foundation

class JsonDataCreator {
    static func create(fileName: String) -> Data {
        let path = (Bundle(for: JsonDataCreator.self).resourcePath! as NSString).appendingPathComponent(fileName)
        return try! Data(contentsOf: URL(fileURLWithPath: path))
    }
    
    
    static func createHanOneData() -> Data {
        return #"""
        [
           {
              "urls":{
                 "small":"https://images.unsplash.com/photo1"
              },
              "user":{
                 "name":"Test",
              },
              "width":100,
              "height":200
           }
        ]
        """#.data(using: .utf8)!
    }
}
