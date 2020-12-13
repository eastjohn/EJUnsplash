//
//  ListViewModelTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/11.
//

import XCTest
@testable import EJUnsplash

class ListViewModelTests: XCTestCase {
    private var sut: ListViewModel!
    private var unsplashServiceStub: UnsplashServiceStub!
    
    override func setUpWithError() throws {
        unsplashServiceStub = UnsplashServiceStub()
        sut = ListViewModel(service: unsplashServiceStub)
    }

    override func tearDownWithError() throws {
        sut = nil
        unsplashServiceStub = nil
    }
    
    
    // MARK: - Given
    func givenHasPhotoDatas(count: Int = 3) {
        var photoDatas = [PhotoInfo]()
        for index in 0..<count {
            photoDatas.append(PhotoInfo(name: "test\(index)", url: URL(string: "http://test\(index).com"), size: CGSize(width: 10 * index, height: 20 * index)))
        }
        sut.photoDatas = photoDatas
    }

    
    // MARK: - Tests
    func testCreateViewModel_ThenSetUnsplashService() {
        let service = UnsplashListService()
        
        sut = ListViewModel(service: service)
        
        XCTAssertTrue(sut.unsplashService === service)
    }
    
    
    func testCalledAddBindingUpdateDatasOfService_WhenCreated() {
        XCTAssertTrue(unsplashServiceStub.wasCalled.contains("called addBindingUpdateDatas(updateHandler:)"))
    }
    
    
    func testFetchDatas_ThenCallFetchDatasOfUnsplashService() throws {
        let expectedWasCalled = "called fetchDatas()"
        
        sut.fetchDatas()
        
        XCTAssertTrue(unsplashServiceStub.wasCalled.contains(expectedWasCalled))
    }
    
    
    func testBindPhotoDatas_ThenSetUpdatePhotoDatasHandler() {
        let expectedRange = 0..<10
        var result: Range<Int>? = nil
        sut.bindPhotoDatas { range in
            result = range
        }
        
        sut.updatePhotoDatasHandler?(expectedRange)
        
        XCTAssertEqual(result, expectedRange)
    }

    
    func testFetchedPhotoDatas_ThenUpdatePhotoDatas() {
        let photoDatas = [PhotoInfo(name: "test1", url: nil, size: CGSize()), PhotoInfo(name: "test2", url: nil, size: CGSize())]
        
        unsplashServiceStub.updateHandler?(photoDatas)
        
        XCTAssertEqual(sut.photoDatas, photoDatas)
    }
    
    
    func testFetchedPhotoDatas_WhenNotExistDatas_ThenCallUpdatePhotoDatasHandler() {
        let expectedRange = 0..<2
        var result: Range<Int>? = nil
        sut.bindPhotoDatas { range in
            result = range
        }
        
        unsplashServiceStub.updateHandler?([PhotoInfo(name: "test1", url: nil, size: CGSize()), PhotoInfo(name: "test2", url: nil, size: CGSize())])
        
        XCTAssertEqual(result, expectedRange)
    }
    
    
    func testFetchedPhotoDatas_WhenExistDatas_ThenCallUpdatePhotoDatasHandler() {
        let expectedRange = 1..<3
        var result: Range<Int>? = nil
        sut.bindPhotoDatas { range in
            result = range
        }
        sut.photoDatas.append(PhotoInfo(name: "test0", url: nil, size: CGSize()))
        unsplashServiceStub.updateHandler?([PhotoInfo(name: "test1", url: nil, size: CGSize()), PhotoInfo(name: "test2", url: nil, size: CGSize())])
        
        XCTAssertEqual(result, expectedRange)
    }
    
    
    func testAddBindingUpdateDatas_ThenNotRetainCycle() {
        var wasCalled = false
        let handler: (Range<Int>)->() = { _ in
            wasCalled = true
        }
        sut.bindPhotoDatas(changedHandler: handler)
        
        sut = nil
        unsplashServiceStub.updateHandler?([PhotoInfo(name: "test1", url: nil, size: CGSize())])
        
        XCTAssertFalse(wasCalled)
    }
    
    
    func testDataCount_WhenNotExistDatas_ThenReturnZero() {
        XCTAssertEqual(sut.dataCount, 0)
    }
    
    
    func testDataCount_WhenExistDatas_ThenReturnDataCount() {
        sut.photoDatas.append(contentsOf: [PhotoInfo(name: "test1", url: nil, size: CGSize()), PhotoInfo(name: "test2", url: nil, size: CGSize())])
        
        XCTAssertEqual(sut.dataCount, 2)
    }
    
    
    func testUpdatePhotoInfo_ThenCallUpdateHandlerWithPhotoInfo() {
        let indexPath = IndexPath(row: 2, section: 0)
        var result: PhotoInfo? = nil
        givenHasPhotoDatas()
        
        sut.updatePhotoInfo(for: indexPath) { photoInfo in
            result = photoInfo
        } completionLoadedPhotoImageHandler: { _ in
        }
        
        XCTAssertEqual(result, sut.photoDatas[indexPath.row])
    }
    
    
    func testUpdatePhotoInfo_WhenNotPrefetch_ThenAddImageOperation() {
        givenHasPhotoDatas()
        let indexPath = IndexPath(row: 2, section: 0)
        sut.imageLoadOperationQueue.isSuspended = true
        
        var wasCalled = false
        sut.updatePhotoInfo(for: indexPath) { _ in
        } completionLoadedPhotoImageHandler: { _ in
            wasCalled = true
        }
        
        XCTAssertEqual(sut.imageLoadOperatorDic[indexPath], sut.imageLoadOperationQueue.operations.last)
        XCTAssertEqual(sut.imageLoadOperatorDic[indexPath]?.url, sut.photoDatas[indexPath.row].url)
        sut.imageLoadOperatorDic[indexPath]?.completionHandler?(UIImage())
        XCTAssertTrue(wasCalled)
    }
    
    
    func testImageLoadOperationQueueIsNotSuspened() {
        XCTAssertFalse(sut.imageLoadOperationQueue.isSuspended)
    }
    
    
    func testUpdatePhotoInfo_WhenPrefetched_ThenCallCompletionLoadedPhotoImageHandler() {
        givenHasPhotoDatas()
        let indexPath = IndexPath(row: 2, section: 0)
        let imageLoadOperator = ImageLoadOperator(url: nil, completionHandler: {_ in})
        imageLoadOperator.photoImage = UIImage()
        sut.imageLoadOperatorDic[indexPath] = imageLoadOperator
        
        
        var result: UIImage?
        sut.updatePhotoInfo(for: indexPath) { _ in
        } completionLoadedPhotoImageHandler: { photoImage in
            result = photoImage
        }
        
        XCTAssertTrue(result === imageLoadOperator.photoImage)
    }
    
    
    func testUpdatePhotoInfo_WhenPrefetchedButNotExistPhotoImage_ThenNotCallCompletionLoadedPhotoImageHandler() {
        givenHasPhotoDatas()
        let indexPath = IndexPath(row: 2, section: 0)
        let imageLoadOperator = ImageLoadOperator(url: nil, completionHandler: {_ in})
        sut.imageLoadOperatorDic[indexPath] = imageLoadOperator
        
        
        var wasCalled = false
        sut.updatePhotoInfo(for: indexPath) { _ in
        } completionLoadedPhotoImageHandler: { _ in
            wasCalled = true
        }
        
        XCTAssertFalse(wasCalled)
    }
    
    
    func testPrefetchRowsAt_WhenIndexPathIsNotContainPhotoDatas_ThenCallFetchDatasOfUnsplashService() {
        let expectedWasCalled = "called fetchDatas()"
        
        sut.prefetchRowsAt(indexPaths: [IndexPath(row: 0, section: 0), IndexPath(row: 2, section: 0)])
        
        XCTAssertTrue(unsplashServiceStub.wasCalled.contains(expectedWasCalled))
    }
    
    
    func testPrefetchRowsAt_WhenIndexPathIsContainPhotoDatas_ThenNotCallFetchDatasOfUnsplashService() {
        let notCalled = "called fetchDatas()"
        givenHasPhotoDatas(count: 7)
        
        sut.prefetchRowsAt(indexPaths: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)])
        
        XCTAssertFalse(unsplashServiceStub.wasCalled.contains(notCalled))
    }
    
    
    func testPrefetchRowsAt_ThenAddImageLoadOperator() {
        givenHasPhotoDatas()
        let indexPaths = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0), IndexPath(row: 3, section: 0)]
        sut.imageLoadOperationQueue.isSuspended = true
        sut.imageLoadOperatorDic[indexPaths[0]] = ImageLoadOperator(url: nil, completionHandler: {_ in})
        
        
        sut.prefetchRowsAt(indexPaths: indexPaths)
        
        
        XCTAssertNotNil(sut.imageLoadOperatorDic[indexPaths[1]])
        XCTAssertNotNil(sut.imageLoadOperatorDic[indexPaths[2]])
        XCTAssertNil(sut.imageLoadOperatorDic[indexPaths[3]])
        XCTAssertEqual(sut.imageLoadOperationQueue.operations, [sut.imageLoadOperatorDic[indexPaths[1]], sut.imageLoadOperatorDic[indexPaths[2]]])
    }
    
    
    func testCancelPrefetchingForRowsAt_ThenCancelOperatorAndRemoveToImageLoadOperatorDic() {
        let indexPaths = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0), IndexPath(row: 3, section: 0)]
        let imageLoadOperators = [ImageLoadOperator(url: nil, completionHandler: {_ in}), ImageLoadOperator(url: nil, completionHandler: {_ in})]
        sut.imageLoadOperatorDic[indexPaths[1]] = imageLoadOperators[0]
        sut.imageLoadOperatorDic[indexPaths[2]] = imageLoadOperators[1]
        
        
        sut.cancelPrefetchingForRowsAt(indexPaths: indexPaths)
        
        
        XCTAssertNil(sut.imageLoadOperatorDic[indexPaths[1]])
        XCTAssertNil(sut.imageLoadOperatorDic[indexPaths[2]])
        XCTAssertTrue(imageLoadOperators[0].isCancelled)
        XCTAssertTrue(imageLoadOperators[1].isCancelled)
    }
    
    
    func testDidEndDisplayingAt_ThenCancelOperatorAndRemoveToImageLoadOperatorDic() {
        let indexPath = IndexPath(row: 2, section: 0)
        let imageLoadOperator = ImageLoadOperator(url: nil, completionHandler: {_ in})
        sut.imageLoadOperatorDic[indexPath] = imageLoadOperator
        
        sut.didEndDisplayingAt(indexPath: indexPath)
        
        XCTAssertNil(sut.imageLoadOperatorDic[indexPath])
        XCTAssertTrue(imageLoadOperator.isCancelled)
    }
    
    
    func testPhotoImageSizeForRowAt_ThenReturnImageSize() {
        let indexPath = IndexPath(row: 2, section: 0)
        givenHasPhotoDatas()
        
        let result = sut.photoImageSizeForRowAt(indexPath: indexPath)
        
        XCTAssertEqual(result, sut.photoDatas[indexPath.row].size)
    }
}
