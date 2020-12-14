//
//  UnsplashSearchService.swift
//  EJUnsplash
//
//  Created by 김요한 on 2020/12/14.
//

import Foundation


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
        let request = UnsplashRequest(api: .list,
                                      parameters: [
                                        .page: "\(currentPage + 1)",
                                        .per_page: "\(perPage)",
                                        .query: query])
        
        networkManager.sendRequest(request) { [weak self] data, error in
//            self?.receiveData(data)
        }
    }
    
    
    func fetchDatas(query: String) {
        self.query = query
        fetchDatas()
    }
    
}
