//
//  UnsplashListService.swift
//  EJUnsplash
//
//  Created by John on 2020/12/11.
//

import Foundation

class UnsplashListService: UnsplashService {
    var updateHandlers = [([PhotoInfo])->()]()
    var networkManager: INetworkManager = NetworkManager()
    
    var currentPage = 0
    var perPage = 10
    
    var isFetching = false
    var canFetch = true
    
    func addBindingUpdateDatas(updateHandler: @escaping ([PhotoInfo]) -> ()) {
        updateHandlers.append(updateHandler)
    }
    
    // TODO: removeUpdateHandler도 구현해야함
    
    func fetchDatas() {
        guard canFetch else { return }
        guard !isFetching else { return }
        isFetching = true
        let request = UnsplashRequest(api: .list,
                                      parameters: [
                                        .page: "\(currentPage + 1)",
                                        .per_page: "\(perPage)"])
        
        networkManager.sendRequest(request) { [weak self] data, error in
            self?.receiveData(data)
        }
    }
    
    
    private func receiveData(_ data: Data?) {
        isFetching = false
        guard let data = data else { return }
        guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else { return }
        
        let phothDatas: [PhotoInfo] = jsonData.compactMap {
            createPhotoInfo($0)
        }
        
        if phothDatas.count < perPage {
            canFetch = false
        }
        
        updateHandlers.forEach { handler in
            handler(phothDatas)
        }
    }
    
    
    private func createPhotoInfo(_ aDic: [String: Any]) -> PhotoInfo? {
        guard let name = (aDic["user"] as? [String: Any])?["name"] as? String else { return nil }
        guard let urlString = (aDic["urls"] as? [String: String])?["small"] else { return nil }
        return PhotoInfo(name: name, url: URL(string: urlString))
    }
}
