//
//  StickyHeaderViewModelTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/15.
//

import XCTest
@testable import EJUnsplash

class StickyHeaderViewModelTests: XCTestCase {
    private var sut: StickyHeaderViewModel!
    private var unsplashServiceStub: UnsplashServiceStub!
    private var imageCacheManager: ImageCacheManager!
    
    override func setUpWithError() throws {
        sut = StickyHeaderViewModel()
        unsplashServiceStub = UnsplashServiceStub()
        sut.unsplashService = unsplashServiceStub
        imageCacheManager = ImageCacheManager()
        sut.imageCacheManager = imageCacheManager
        imageCacheManager.imageCache.setObject(UIImage(), forKey: NSURL(string: "http://test1.com")!)
        imageCacheManager.imageCache.setObject(UIImage(), forKey: NSURL(string: "http://test2.com")!)
        imageCacheManager.imageCache.setObject(UIImage(), forKey: NSURL(string: "http://test3.com")!)
    }

    override func tearDownWithError() throws {
        sut = nil
        unsplashServiceStub = nil
        imageCacheManager = nil
    }
    
    // MARK: - Given
    func givenHasPhotoDatas() {
        sut.photoDatas = [PhotoInfo(name: "test1", url: URL(string: "http://test1.com"), size: CGSize()),
                          PhotoInfo(name: "test2", url: URL(string: "http://test2.com"), size: CGSize()),
                          PhotoInfo(name: "test3", url: URL(string: "http://test3.com"), size: CGSize())]
    }

    
    // MARK: - Tests
    func testConfirmUnsplashService_WhenCreated() throws {
        sut = StickyHeaderViewModel()
        XCTAssertTrue(sut.unsplashService is UnsplashRandomService)
    }
    
    
    func testConfirmImageCacheManager_WhenCreated() throws {
        sut = StickyHeaderViewModel()
        XCTAssertTrue(sut.imageCacheManager === ImageCacheManager.shared)
    }
    
    
    func testBindingService_WhenCreated() {
        let expectedPhotoInfo = PhotoInfo(name: "test2", url: nil, size: CGSize())
        
        unsplashServiceStub.updateHandler?([expectedPhotoInfo])
        
        XCTAssertEqual(sut.photoDatas[0], expectedPhotoInfo)
    }
    
    
    func testBindingService_ThenNotRetainCycle() {
        weak var weakSut = sut
        
        sut = nil
        
        XCTAssertNil(weakSut)
    }

    
    func testBindBackgroundImage_ThenSetUpdateHandler() {
        let expectedImage = UIImage()
        
        var result: UIImage?
        sut.bindBackgroundImage { image in
            result = image
        }
        sut.updateHandler?(expectedImage)
        
        XCTAssertTrue(result === expectedImage)
    }
    
    
    func testUpdatePhotoDatas_ThenCallUpdateHandler() {
        let expectation = self.expectation(description: "updatePhotoDatas")
        
        sut.bindBackgroundImage { image in
            XCTAssertTrue(image === self.imageCacheManager.imageCache.object(forKey: self.sut.photoDatas[0].url! as NSURL))
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }
        DispatchQueue.global().async {
//            self.givenHasPhotoDatas()
            self.unsplashServiceStub.updateHandler?([PhotoInfo(name: "test1", url: URL(string: "http://test1.com"), size: CGSize())])
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testDefaultTimeIntervalIs3() {
        XCTAssertEqual(sut.timeInterval, 3)
    }
    
    
    func whenReceivePhotoDatas(expectedFulfillmentCount: Int) -> UIImage? {
        let expectation = self.expectation(description: "updatePhotoDatas")
        expectation.expectedFulfillmentCount = expectedFulfillmentCount
        var result: UIImage?
        sut.timeInterval = 0.01
        sut.bindBackgroundImage { image in
            result = image
            expectation.fulfill()
        }

        givenHasPhotoDatas()
        
        wait(for: [expectation], timeout: 1)
        
        return result
    }
    
    
    func testLoadImage_ThenCallLoadImageAfterIntervalTime() {
        let result = whenReceivePhotoDatas(expectedFulfillmentCount: 2)
        XCTAssertTrue(result === self.imageCacheManager.imageCache.object(forKey: self.sut.photoDatas[1].url! as NSURL))
    }
    
    
    func testLoadImage_WhenIndexIsLast_ThenCallNextIndexIsFirstIndex() {
        let result = whenReceivePhotoDatas(expectedFulfillmentCount: 4)
        XCTAssertTrue(result === self.imageCacheManager.imageCache.object(forKey: self.sut.photoDatas[0].url! as NSURL))
    }
}
