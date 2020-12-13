//
//  ImageCacheManagerTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/13.
//

import XCTest
@testable import EJUnsplash

class ImageCacheManagerTests: XCTestCase {
    private var sut: ImageCacheManager!
    private var networkManagerStub: NetworkManagerStub!
    
    override func setUpWithError() throws {
        sut = ImageCacheManager()
        networkManagerStub = NetworkManagerStub()
        sut.networkManager = networkManagerStub
    }

    override func tearDownWithError() throws {
        sut = nil
        networkManagerStub = nil
    }

    
    func testConfirmImageCache_WheCreated() throws {
        XCTAssertNotNil(sut.imageCache)
    }
    
    
    func testConfirmNetworkManager_WhenCreated() {
        sut = ImageCacheManager()
        XCTAssertTrue(sut.networkManager is NetworkManager)
    }
    
    
    func testLoadImage_WhenCached_ThenCallCompletionHandler() {
        let expectedImage = UIImage()
        let url = URL(string: "http://test.com")!
        sut.imageCache.setObject(expectedImage, forKey: url as NSURL)
        
        var result:UIImage? = nil
        sut.loadImage(url: url) { result = $0 }
        
        XCTAssertTrue(result === expectedImage)
    }
    
    
    func testLoadImage_WhenNotCached_ThenCallSendDownloadRequestOfNetworkManager() {
        let expectedURL = URL(string: "http://test.com")!
        let expectedWasCalled = "called sendDownloadRequest(url:completionHandler:)"
        
        sut.loadImage(url: expectedURL) { _ in }
        
        XCTAssertTrue(networkManagerStub.wasCalled.contains(expectedWasCalled))
        XCTAssertEqual(networkManagerStub.paramURL, expectedURL)
    }
    
    
    func testLoadImage_WhenNotCached_ThenCallCompletionHandler() {
        let expectedData = JsonDataCreator.create(fileName: "sampleImage.png")
        let expectedImage = UIImage(data: expectedData)
        
        var result:UIImage? = nil
        sut.loadImage(url: URL(string: "http://test.com")!) { result = $0 }
        networkManagerStub.completionHandler?(expectedData, nil)
        
        XCTAssertEqual(result?.pngData(), expectedImage?.pngData())
    }
    
    
    func testLoadImage_WhenNotCachedAndOccurError_ThenNotCallCompletionHandler() {
        var result:UIImage? = nil
        
        sut.loadImage(url: URL(string: "http://test.com")!) { result = $0 }
        networkManagerStub.completionHandler?(nil, NSError(domain: "test", code: -1, userInfo: nil))
        
        XCTAssertNil(result)
    }
    
    
    func testLoadImage_WhenNotCached_ThenAddReceivedDataToImageCache() {
        let expectedData = JsonDataCreator.create(fileName: "sampleImage.png")
        let expectedImage = UIImage(data: expectedData)
        let url = URL(string: "http://test.com")!
        
        sut.loadImage(url: url) { _ in }
        networkManagerStub.completionHandler?(expectedData, nil)
        
        XCTAssertEqual(expectedImage?.pngData(), sut.imageCache.object(forKey: url as NSURL)?.pngData())
    }
    
    
    func testLoadImage_ThenNotRetainCycle() {
        let imageCache = sut.imageCache
        let url = URL(string: "http://test.com")!
        
        sut.loadImage(url: url) { _ in }
        sut = nil
        networkManagerStub.completionHandler?(JsonDataCreator.create(fileName: "sampleImage.png"), nil)
        
        XCTAssertNil(imageCache.object(forKey: url as NSURL))
    }
}
