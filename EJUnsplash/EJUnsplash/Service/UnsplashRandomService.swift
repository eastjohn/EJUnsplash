//
//  UnsplashRandomService.swift
//  EJUnsplash
//
//  Created by John on 2020/12/15.
//

import UIKit


class UnsplashRandomService: UnsplashService {
    var networkManager: INetworkManager = NetworkManager()
    var updateHandler: ( (Result<[PhotoInfo], Error>)->() )?
    var randomCount = 5
    
    func addBindingUpdateDatas(updateHandler: @escaping (Result<[PhotoInfo], Error>) -> ()) {
        self.updateHandler = updateHandler
    }
    
    func removeBindingUpdateDatas() {
        updateHandler = nil
    }
    
    func fetchDatas() {
        let request = UnsplashRequest(api: .random,
                                      parameters: [.count: "\(randomCount)"])

        networkManager.sendRequest(request) { [weak self] data, error in
            if let error = error {
                self?.receiveError(error)
            } else {
                self?.receiveData(data)
            }
        }
    }
    
    func fetchDatas(query: String) {
    }
    
    
    private func receiveError(_ error: Error) {
        updateHandler?(.failure(error))
    }
    
    
    private func receiveData(_ data: Data?) {
        guard let data = data else { return }
        guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else {
            updateHandler?(.failure(ServiceError.invalidJson))
            return
        }
        
        let phothDatas: [PhotoInfo] = jsonData.compactMap {
            PhotoInfoFactory.createPhotoInfo(jsonDic: $0)
        }
        
        updateHandler?(.success(phothDatas))
    }
}
