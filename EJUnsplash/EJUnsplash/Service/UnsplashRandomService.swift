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
            createPhotoInfo($0)
        }
        
        updateHandler?(phothDatas)
    }
    
    
    private func createPhotoInfo(_ aDic: [String: Any]) -> PhotoInfo? {
        guard let name = (aDic["user"] as? [String: Any])?["name"] as? String else { return nil }
        guard let urlString = (aDic["urls"] as? [String: String])?["small"] else { return nil }
        guard let width = aDic["width"] as? Int else { return nil }
        guard let height = aDic["height"] as? Int else { return nil }
        
        return PhotoInfo(name: name, url: URL(string: urlString), size: CGSize(width: width, height: height))
    }
}
