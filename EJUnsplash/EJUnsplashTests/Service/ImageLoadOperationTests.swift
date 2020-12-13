//
//  ImageLoadOperationTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/13.
//

import XCTest
@testable import EJUnsplash

class ImageLoadOperationTests: XCTestCase {
    private var sut: ImageLoadOperator!
    private var imageCacheManagerStub: ImageCacheManagerStub!
    private var resultImage: UIImage?
    private var expectation: XCTestExpectation!
    
    override func setUpWithError() throws {
        sut = ImageLoadOperator(url: URL(string: "http://test.com"), completionHandler: receiveImage(image:))
        imageCacheManagerStub = ImageCacheManagerStub()
        sut.imageCacheManager = imageCacheManagerStub
    }

    override func tearDownWithError() throws {
        sut = nil
        resultImage = nil
        imageCacheManagerStub = nil
        expectation = nil
    }
    
    
    func receiveImage(image: UIImage) {
        resultImage = image
        XCTAssertTrue(Thread.isMainThread)
        expectation.fulfill()
    }

    
    func testConfirmImageCacheManager_WhenCreated() throws {
        sut = ImageLoadOperator(url: nil, completionHandler: { _ in})
        XCTAssertTrue(sut.imageCacheManager === ImageCacheManager.shared)
    }
    
    
    func testRun_ThenCallLoadImageOfImageCacheManager() {
        let expectedWasCalled = "called loadImage(url:completionHandler:)"
        
        sut.main()
        
        XCTAssertTrue(imageCacheManagerStub.wasCalled.contains(expectedWasCalled))
    }
    
    
    func testRun_WhenCancled_ThenNotCallLoadImageOfImageCacheManager() {
        let notCalled = "called loadImage(url:completionHandler:)"
        sut.cancel()
        
        sut.main()
        
        XCTAssertFalse(imageCacheManagerStub.wasCalled.contains(notCalled))
    }
    
    
    func testRun_WhenReceiveImage_ThenCallCompletionHandler() {
        expectation = expectation(description: "loadImage")
        let expectedImage = UIImage()
        
        sut.main()
        DispatchQueue.global().async {
            self.imageCacheManagerStub.completionHandler?(expectedImage)
        }
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(resultImage === expectedImage)
    }
    
    
    func testRun_WhenCancledDuringLoadImage_ThenNotCallCompletionHandler() {
        expectation = expectation(description: "loadImage")
        
        sut.main()
        DispatchQueue.global().async {
            self.sut.cancel()
            self.imageCacheManagerStub.completionHandler?(UIImage())
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertNil(resultImage)
    }
    
    
    func testRun_WhenSutIsNilDuringLoadImage_ThenNotCallCompletionHandler() {
        expectation = expectation(description: "loadImage")
        
        sut.main()
        DispatchQueue.global().async {
            self.sut = nil
            self.imageCacheManagerStub.completionHandler?(UIImage())
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertNil(resultImage)
    }

}
