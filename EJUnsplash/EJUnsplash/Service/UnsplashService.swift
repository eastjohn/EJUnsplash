//
//  UnsplashService.swift
//  EJUnsplash
//
//  Created by John on 2020/12/11.
//

import Foundation

protocol UnsplashService: class {
    func addBindingUpdateDatas(updateHandler: @escaping (Result<[PhotoInfo], Error>)->())
    func removeBindingUpdateDatas()
    func fetchDatas()
    func fetchDatas(query: String)
}
