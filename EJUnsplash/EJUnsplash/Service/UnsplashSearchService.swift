//
//  UnsplashSearchService.swift
//  EJUnsplash
//
//  Created by John on 2020/12/14.
//

import UIKit


class UnsplashSearchService: UnsplashService {
    var updateHandlers = [([PhotoInfo])->()]()
    var networkManager: INetworkManager = NetworkManager()
        
    var currentPage = 0
    var perPage = 10
    var query = ""
        
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
        guard query.count > 0 else { return }
        guard canFetch else { return }
        guard !isFetching else { return }
        isFetching = true
        let request = UnsplashRequest(api: .search,
                                      parameters: [
                                        .page: "\(currentPage + 1)",
                                        .per_page: "\(perPage)",
                                        .query: query])
        
        networkManager.sendRequest(request) { [weak self] data, error in
            self?.receiveData(data)
        }
    }
    
    
    func fetchDatas(query: String) {
        self.query = query
        isFetching = false
        canFetch = true
        fetchDatas()
    }
    
    
    private func receiveData(_ data: Data?) {
        isFetching = false
        guard let data = data else { return }
        guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
              let results = jsonData[UnsplashJsonParameterKey.results.rawValue] as? [[String:Any]] else { return }
        
        let phothDatas: [PhotoInfo] = results.compactMap {
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
