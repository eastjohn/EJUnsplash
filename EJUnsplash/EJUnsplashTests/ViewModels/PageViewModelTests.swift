//
//  PageViewModelTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/14.
//

import XCTest
@testable import EJUnsplash

class PageViewModelTests: XCTestCase {
    private var sut: PageViewModel!
    private var unsplashServiceStub: UnsplashServiceStub!

    override func setUpWithError() throws {
        unsplashServiceStub = UnsplashServiceStub()
        sut = PageViewModel(service: unsplashServiceStub)
    }

    override func tearDownWithError() throws {
        sut = nil
        unsplashServiceStub = nil
    }
    
    // MARK: - Given
    func givenHasPhotoDatas() {
        for index in 0..<10 {
            sut.photoDatas.append(PhotoInfo(name: "test\(index)", url: URL(string: "http://test\(index).com"), size: CGSize()))
        }
    }
    

    // MARK: - Tests
    func testSetPhotoDatas_ThenSetPhotoDatas() throws {
        let expectedPhotoDatas = [PhotoInfo(name: "test", url: nil, size: CGSize())]
        
        sut.setPhotoDatas(expectedPhotoDatas)
        
        XCTAssertEqual(sut.photoDatas, expectedPhotoDatas)
    }
    
    
    func testBindingService_WhenCreated() {
        let expectedPhotoInfo = PhotoInfo(name: "test2", url: nil, size: CGSize())
        sut.photoDatas = [PhotoInfo(name: "test1", url: nil, size: CGSize())]
        
        unsplashServiceStub.updateHandler?(.success([expectedPhotoInfo]))
        
        XCTAssertEqual(sut.photoDatas[1], expectedPhotoInfo)
    }
    
    
    func testBindingService_ThenNotRetainCycle() {
        weak var weakSut = sut
        
        sut = nil
        
        XCTAssertNil(weakSut)
    }
    
    
    func testUrlAt_WhenIndexIsLessThanZero_ThenReturnNil() {
        XCTAssertNil(sut.urlAt(-1))
    }
    
    
    func testUrlAt_WhenIndexIsGreaterThanPhotoDatas_ThenReturnNil() {
        givenHasPhotoDatas()
        XCTAssertNil(sut.urlAt(10))
    }
    
    
    func testUrlAt_WhenIndexIsZero_ThenReturnURL() {
        givenHasPhotoDatas()
        XCTAssertEqual(sut.urlAt(0), sut.photoDatas[0])
    }
    
    
    func testUrlAt_WhenIndexIsTwo_ThenReturnURL() {
        givenHasPhotoDatas()
        XCTAssertEqual(sut.urlAt(2), sut.photoDatas[2])
    }

    
    func testUrlAt_WhenNeedFetch_ThenCallFetchDatasOfUnsplashService() {
        givenHasPhotoDatas()
        let expectedWasCalled = "called fetchDatas()"
        
        _ = sut.urlAt(6)
        
        XCTAssertTrue(unsplashServiceStub.wasCalled.contains(expectedWasCalled))
    }
    
    
    func testUrlAt_WhenNotNeedFetch_ThenCallFetchDatasOfUnsplashService() {
        givenHasPhotoDatas()
        let notCalled = "called fetchDatas()"
        
        _ = sut.urlAt(5)
        
        XCTAssertFalse(unsplashServiceStub.wasCalled.contains(notCalled))
    }
    
    
    func testDeinit_ThenCallRemoveBindingUpdateDatas() {
        let expectedWasCalled = "called removeBindingUpdateDatas()"
        
        sut = nil
        
        XCTAssertTrue(unsplashServiceStub.wasCalled.contains(expectedWasCalled))
    }
    
}
