//
//  UnsplashService.swift
//  EJUnsplash
//
//  Created by John on 2020/12/11.
//

import Foundation

protocol UnsplashService: class {
    func addBindingUpdateDatas(updateHandler: @escaping ([PhotoInfo])->())
    func removeBindingUpdateDatas()
    func fetchDatas()
}
