//
//  UnsplashRandomServiceTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/15.
//

import XCTest
@testable import EJUnsplash

class UnsplashRandomServiceTests: XCTestCase {
    private var sut: UnsplashRandomService!
    private var networkManagerStub: NetworkManagerStub!

    override func setUpWithError() throws {
        sut = UnsplashRandomService()
        networkManagerStub = NetworkManagerStub()
        sut.networkManager = networkManagerStub
    }

    override func tearDownWithError() throws {
        sut = nil
        networkManagerStub = nil
    }

    
    func testConfirmNetworkManager_WhenCreated() {
        sut = UnsplashRandomService()
        XCTAssertTrue(sut.networkManager is NetworkManager)
    }
    
    
    func testAddingBindingUpdateDatas_ThenAddedClosure() throws {
        var wasCalled = false
        sut.addBindingUpdateDatas { _ in
            wasCalled = true
        }
        
        sut.updateHandler?([PhotoInfo(name: "", url: nil, size: CGSize())])
        
        XCTAssertTrue(wasCalled)
    }
    
    
    func testRemoveBindingUpdateDatas_ThenUpdateHandlerIsNil() throws {
        sut.addBindingUpdateDatas { _ in }
        
        sut.removeBindingUpdateDatas()
        
        XCTAssertNil(sut.updateHandler)
    }
    
    
    func testDefaultRandomCountIs5() {
        XCTAssertEqual(sut.randomCount, 5)
    }
    
    
    func testFetchDatas_WhenFirstFetching_ThenCallSendRequestOfNetworkManager() {
        let expectedWasCalled = "called sendRequest(_:completionHandler:)"
        let expectedRequest = UnsplashRequest(api: .random, parameters:[.count: "5"])

        sut.fetchDatas()

        XCTAssertTrue(networkManagerStub.wasCalled.contains(expectedWasCalled))
        XCTAssertEqual(networkManagerStub.paramRequest, expectedRequest)
    }
    
    
    func testFetchData_ThenNotRetainCylcle() {
        weak var weakSut = sut
        
        sut.fetchDatas()
        sut = nil
        
        XCTAssertNil(weakSut)
    }
    
    
    func whenFetchData(jsonData: Data?) {
        sut.fetchDatas()
        networkManagerStub.completionHandler?(jsonData, nil)
    }
    
    
    func whenFetchData(jsonFile: String) {
        let jsonData = JsonDataCreator.create(fileName: jsonFile)
        whenFetchData(jsonData: jsonData)
    }
    
    
    func testReceiveData_ThenCallUpdateHandler() {
        let expectedPhotoData = PhotoInfo(name: "Test", url: URL(string: "https://images.unsplash.com/photo1"), size: CGSize(width: 100, height: 200))
        var result: [PhotoInfo]? = nil
        sut.addBindingUpdateDatas { photoInfos in
            result = photoInfos
        }
        
        let jsonData = JsonDataCreator.createHasOneData()
        whenFetchData(jsonData: jsonData)
        
        XCTAssertEqual(result, [expectedPhotoData])
    }

}
