//
//  DetailViewModelTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/14.
//

import XCTest
@testable import EJUnsplash

class DetailViewModelTests: XCTestCase {
    private var sut: DetailViewModel!
    private var imageCacheManagerStub: ImageCacheManagerStub!
    
    override func setUpWithError() throws {
        sut = DetailViewModel(photoInfo: PhotoInfo(name: "test", url: URL(string: "http://test.com"), size: CGSize()))
        imageCacheManagerStub = ImageCacheManagerStub()
    }

    override func tearDownWithError() throws {
        sut = nil
        imageCacheManagerStub = nil
    }

    // MARK: - Given
    func givenHasImageCacheManagerStub() {
        sut.imageCacheManager = imageCacheManagerStub
    }
    
    
    // MARK: - Tests
    func testConfirmImageCacheManager_WhenCreated() throws {
        XCTAssertTrue(sut.imageCacheManager === ImageCacheManager.shared)
    }
    
    
    func testBindPhotoImage_ThenCallLoadImageOfImageCacheManager() {
        let expectedWasCalled = "called loadImage(url:completionHandler:)"
        givenHasImageCacheManagerStub()
        
        sut.bindPhotoImage { _ in }
        
        XCTAssertTrue(imageCacheManagerStub.wasCalled.contains(expectedWasCalled))
        XCTAssertEqual(imageCacheManagerStub.paramURL, sut.photoInfo.url)
    }
    
    func testBindPhotoImage_WhenReceiveImage_ThenCallCompletionHandler() {
        let expectedImage = UIImage()
        let expectation = self.expectation(description: "loadImage")
        givenHasImageCacheManagerStub()
        
        var result: UIImage? = nil
        sut.bindPhotoImage { image in
            result = image
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }
        DispatchQueue.global().async {
            self.imageCacheManagerStub.completionHandler?(expectedImage)
        }
        
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(result === expectedImage)
    }
}
