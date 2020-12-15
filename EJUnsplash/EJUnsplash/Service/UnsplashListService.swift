//
//  UnsplashListService.swift
//  EJUnsplash
//
//  Created by John on 2020/12/11.
//

import UIKit

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
    
    func removeBindingUpdateDatas() {
        guard updateHandlers.count > 0 else { return }
        updateHandlers.removeLast()
    }
    
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
    
    
    func fetchDatas(query: String) {
    }
    
    
    private func receiveData(_ data: Data?) {
        isFetching = false
        guard let data = data else { return }
        guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else { return }
        
        let phothDatas: [PhotoInfo] = jsonData.compactMap {
            PhotoInfoFactory.createPhotoInfo(jsonDic: $0)
        }
        
        if phothDatas.count < perPage {
            canFetch = false
        }
        currentPage += 1
        
        updateHandlers.forEach { handler in
            handler(phothDatas)
        }
    }
}
