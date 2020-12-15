//
//  UnsplashRandomService.swift
//  EJUnsplash
//
//  Created by John on 2020/12/15.
//

import UIKit


class UnsplashRandomService: UnsplashService {
    var networkManager: INetworkManager = NetworkManager()
    var updateHandler: ( ([PhotoInfo])->() )?
    var randomCount = 5
    
    func addBindingUpdateDatas(updateHandler: @escaping ([PhotoInfo]) -> ()) {
        self.updateHandler = updateHandler
    }
    
    func removeBindingUpdateDatas() {
        updateHandler = nil
    }
    
    func fetchDatas() {
        let request = UnsplashRequest(api: .random,
                                      parameters: [.count: "\(randomCount)"])

        networkManager.sendRequest(request) { [weak self] data, error in
            self?.receiveData(data)
        }
    }
    
    func fetchDatas(query: String) {
    }
    
    
    private func receiveData(_ data: Data?) {
        guard let data = data else { return }
        guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else { return }
        
        let phothDatas: [PhotoInfo] = jsonData.compactMap {
            PhotoInfoFactory.createPhotoInfo(jsonDic: $0)
        }
        
        updateHandler?(phothDatas)
    }
}
