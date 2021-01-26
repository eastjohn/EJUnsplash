//
//  ServiceError.swift
//  EJUnsplash
//
//  Created by 김요한 on 2021/01/26.
//

import Foundation


enum ServiceError: Error, Equatable {
    case unknown
    case invalidJson
}
