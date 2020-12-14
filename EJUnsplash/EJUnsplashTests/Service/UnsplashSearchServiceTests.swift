//
//  UnsplashSearchServiceTests.swift
//  EJUnsplashTests
//
//  Created by 김요한 on 2020/12/14.
//

import XCTest
@testable import EJUnsplash

class UnsplashSearchServiceTests: XCTestCase {
    private var sut: UnsplashSearchService!
    private var networkManagerStub: NetworkManagerStub!

    override func setUpWithError() throws {
        sut = UnsplashSearchService()
        networkManagerStub = NetworkManagerStub()
        sut.networkManager = networkManagerStub
    }

    override func tearDownWithError() throws {
        sut = nil
        networkManagerStub = nil
    }

    
    func testConfirmNetworkManager_WhenCreated() {
        sut = UnsplashSearchService()
        XCTAssertTrue(sut.networkManager is NetworkManager)
    }

    
    func testAddingBindingUpdateDatas_ThenAddedClosure() throws {
        var wasCalled = false
        sut.addBindingUpdateDatas { _ in
            wasCalled = true
        }
        
        sut.updateHandlers.forEach { $0([PhotoInfo(name: "", url: nil, size: CGSize())]) }
        
        XCTAssertEqual(sut.updateHandlers.count, 1)
        XCTAssertTrue(wasCalled)
    }
    
    
    func testTwiceAddingBindingUpdateDatas_ThenAddedClosure() throws {
        var calledCount = 0
        sut.addBindingUpdateDatas { _ in
            calledCount += 1
        }
        
        sut.addBindingUpdateDatas { _ in
            calledCount += 1
        }
        
        sut.updateHandlers.forEach { $0([PhotoInfo(name: "", url: nil, size: CGSize())]) }
        
        XCTAssertEqual(sut.updateHandlers.count, 2)
        XCTAssertEqual(calledCount, 2)
    }
    
    
    func testRemoveBindingUpdateDatas_ThenRemoveLastUpdateHandler() {
        var wasCalled = ""
        sut.addBindingUpdateDatas { _ in
            wasCalled += "called first"
        }
        sut.addBindingUpdateDatas { _ in
            wasCalled += "called second"
        }
        
        
        sut.removeBindingUpdateDatas()
        sut.updateHandlers.forEach { $0([PhotoInfo(name: "", url: nil, size: CGSize())]) }
        
        
        XCTAssertEqual(sut.updateHandlers.count, 1)
        XCTAssertEqual(wasCalled, "called first")
    }
    
    
    func testRemoveBindingUpdateDatas_WhenEmptyUpdateHandlers_ThenNotOccurFataError() {
        sut.removeBindingUpdateDatas()
    }
    
    
    func testCurrentPageIsZero_WhenCreated() {
        XCTAssertEqual(sut.currentPage, 0)
    }
    
    
    func testDefaultPerPageIs10() {
        XCTAssertEqual(sut.perPage, 10)
    }
    
    
    func testFetchDatasWithQuery_ThenCallSendRequestOfNetworkManager() {
        let query = "test123"
        let expectedRequest = UnsplashRequest(api: .search, parameters:[.page:"1", .per_page:"10", .query: query])
        let expectedWasCalled = "called sendRequest(_:completionHandler:)"
        
        sut.fetchDatas(query: query)
        
        XCTAssertTrue(networkManagerStub.wasCalled.contains(expectedWasCalled))
        XCTAssertEqual(networkManagerStub.paramRequest, expectedRequest)
    }
    
    
    func whenFetchDatas_ThenCallSendRequestOfNetworkManager(expectedRequest: UnsplashRequest) {
        let expectedWasCalled = "called sendRequest(_:completionHandler:)"
        
        sut.fetchDatas()

        XCTAssertTrue(networkManagerStub.wasCalled.contains(expectedWasCalled))
        XCTAssertEqual(networkManagerStub.paramRequest, expectedRequest)
    }
    
    
    func testFetchDatas_WhenFirstFetching_ThenCallSendRequestOfNetworkManager() {
        let expectedReqeust = UnsplashRequest(api: .search, parameters:[.page:"1", .per_page:"10", .query: "test"])

        whenFetchDatas_ThenCallSendRequestOfNetworkManager(expectedRequest: expectedReqeust)
    }
    
    
    func testFetchDatas_WhenSecondFetching_ThenCallSendRequestOfNetworkManager() {
        let expectedReqeust = UnsplashRequest(api: .list, parameters:[.page:"2", .per_page:"10"])
        sut.currentPage = 1
        
        whenFetchDatas_ThenCallSendRequestOfNetworkManager(expectedRequest: expectedReqeust)
    }
    
    
    func testFetchDatas_WhenPerPageIs30_ThenRequestPerPageIs30() {
        let expectedReqeust = UnsplashRequest(api: .list, parameters:[.page:"1", .per_page:"30"])
        sut.perPage = 30
        
        whenFetchDatas_ThenCallSendRequestOfNetworkManager(expectedRequest: expectedReqeust)
    }

    
//    func testDefaultIsFetchingIsFalse() {
//        XCTAssertFalse(sut.isFetching)
//    }
//    
//    
//    func testFetchDatas_WhenNotFetching_ThenIsFetchingIsTrue() {
//        sut.fetchDatas()
//        
//        XCTAssertTrue(sut.isFetching)
//    }
//    
//    
//    func testFetchDatas_WhenIsFetchingIsTrue_ThenNotCallSendRequestOfNetworkManager() {
//        let notCalled = "called sendRequest(_:completionHandler:)"
//        sut.isFetching = true
//        
//        sut.fetchDatas()
//        
//        
//        XCTAssertFalse(networkManagerStub.wasCalled.contains(notCalled))
//    }
//    
//    
//    func testDefaultCanFetchIsTrue() {
//        XCTAssertTrue(sut.canFetch)
//    }
//    
//    
//    func testFetchDatas_WhenCanFetchIsFalse_ThenNotCallSendRequestOfNetworkManager() {
//        let notCalled = "called sendRequest(_:completionHandler:)"
//        sut.canFetch = false
//        
//        sut.fetchDatas()
//        
//        XCTAssertFalse(networkManagerStub.wasCalled.contains(notCalled))
//    }
//    
//    
//    func whenFetchData(jsonData: Data?) {
//        sut.fetchDatas()
//        networkManagerStub.completionHandler?(jsonData, nil)
//    }
//    
//    
//    func whenFetchData(jsonFile: String) {
//        let jsonData = JsonDataCreator.create(fileName: jsonFile)
//        whenFetchData(jsonData: jsonData)
//    }
//    
//    
//    func testReceiveData_ThenCallUpdateHandler() {
//        let expectedPhotoData = PhotoInfo(name: "Test", url: URL(string: "https://images.unsplash.com/photo1"), size: CGSize(width: 100, height: 200))
//        var result: [PhotoInfo]? = nil
//        sut.addBindingUpdateDatas { photoInfos in
//            result = photoInfos
//        }
//        
//        let jsonData = JsonDataCreator.createHanOneData()
//        whenFetchData(jsonData: jsonData)
//        
//        XCTAssertEqual(result, [expectedPhotoData])
//    }
//    
//    
//    func testReceiveData_WhenHasTenDatas_ThenCallUpdateHandler() {
//        var result: [PhotoInfo]? = nil
//        sut.addBindingUpdateDatas { photoInfos in
//            result = photoInfos
//        }
//
//        whenFetchData(jsonFile: "page1.json")
//        
//        XCTAssertEqual(result?.count, 10)
//    }
//    
//    
//    func testReceiveData_ThenCallAllUpdateHandler() {
//        var calledCount = 0
//        sut.addBindingUpdateDatas { photoInfos in
//            calledCount += 1
//        }
//        sut.addBindingUpdateDatas { photoInfos in
//            calledCount += 1
//        }
//        
//        whenFetchData(jsonFile: "page1.json")
//        
//        XCTAssertEqual(calledCount, 2)
//    }
//    
//    
//    func testReceiveData_ThenIsFectchingIsFalse() {
//        whenFetchData(jsonFile: "page1.json")
//        
//        XCTAssertFalse(sut.isFetching)
//    }
//    
//    
//    func testReceiveData_WhenDataIsNil_ThenIsFectchingIsFalse() {
//        whenFetchData(jsonData: nil)
//        
//        XCTAssertFalse(sut.isFetching)
//    }
//    
//    
//    func testReceiveData_WhenPhotoDataCountIsLessThanPerPage_ThenCanFetchIsFalse() {
//        let jsonData = JsonDataCreator.createHanOneData()
//        whenFetchData(jsonData: jsonData)
//        
//        XCTAssertFalse(sut.canFetch)
//    }
//    
//    
//    func testReceiveData_ThenIncreaseCurrentPage() {
//        let expectedCurrentPage = sut.currentPage + 1
//        
//        whenFetchData(jsonFile: "page1.json")
//        
//        XCTAssertEqual(sut.currentPage, expectedCurrentPage)
//    }
//    
//    
//    func testReceiveDataWithError_ThenNotIncreaseCurrentPage() {
//        let expectedCurrentPage = sut.currentPage
//        
//        whenFetchData(jsonData: nil)
//        
//        XCTAssertEqual(sut.currentPage, expectedCurrentPage)
//    }
//    
//    
//    func testFetchData_ThenNotRetainCylcle() {
//        var wasCalled = false
//        sut.addBindingUpdateDatas { _ in
//            wasCalled = true
//        }
//        
//        sut.fetchDatas()
//        sut = nil
//        networkManagerStub.completionHandler?(JsonDataCreator.createHanOneData(), nil)
//        
//        XCTAssertFalse(wasCalled)
//    }

}
