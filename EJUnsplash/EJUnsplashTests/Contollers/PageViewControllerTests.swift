//
//  PageViewControllerTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/13.
//

import XCTest
@testable import EJUnsplash

class PageViewControllerTests: XCTestCase {
    private var sut: PageViewController!
    private var viewModelStub: PageViewModelStub!
    
    override func setUpWithError() throws {
        sut = PageViewController.createFromStoryboard(unsplashService: UnsplashServiceStub())
        viewModelStub = PageViewModelStub()
        sut.viewModel = viewModelStub
    }

    
    override func tearDownWithError() throws {
        sut = nil
        viewModelStub = nil
    }

    
    // MARK: - Given
    func givenHasPhotoDatas() {
        let photoDatas = [PhotoInfo(name: "test1", url: URL(string: "http://test1.com"), size: CGSize()),
                          PhotoInfo(name: "test2", url: URL(string: "http://test2.com"), size: CGSize()),
                          PhotoInfo(name: "test3", url: URL(string: "http://test3.com"), size: CGSize()),
                          PhotoInfo(name: "test4", url: URL(string: "http://test4.com"), size: CGSize())]
        viewModelStub.setPhotoDatas(photoDatas)
    }
    
    
    // MARK: - Tests
    func testConfirmViewModel_WhenCreated() throws {
        let expectedUnsplashService = UnsplashListService()
        
        sut = PageViewController.createFromStoryboard(unsplashService: expectedUnsplashService)
        
        XCTAssertNotNil(sut.viewModel)
        XCTAssertTrue((sut.viewModel as? PageViewModel)?.unsplashService === expectedUnsplashService)
    }
    
    
    func testSetPhotoDatas_ThenSetPhotoDatasOfViewModel() {
        let expectedPhotoDatas = [PhotoInfo(name: "test", url: nil, size: CGSize())]
        
        sut.setPhotoDatas(expectedPhotoDatas)
        
        XCTAssertEqual(viewModelStub.photoDatas, expectedPhotoDatas)
    }

    
    func testViewDidLoad_ThenDataSourceIsPageViewController() {
        sut.viewDidLoad()
        
        XCTAssertTrue(sut.dataSource === sut)
    }
    
    
    func testViewDidLoad_ThenAddDetailViewControllerToPageViewController() {
        givenHasPhotoDatas()
        sut.selectedIndex = 0
        
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.viewControllers?.count, 1)
        XCTAssertEqual(((sut.viewControllers?.first as? DetailViewController)?.viewModel as? DetailViewModel)?.photoInfo, viewModelStub.photoDatas[sut.selectedIndex])
        XCTAssertEqual((sut.viewControllers?.first as? DetailViewController)?.index, sut.selectedIndex)
    }

    
    func testPageViewControllerViewControllerBefore_ThenReturnPreviousViewController() {
        givenHasPhotoDatas()
        let expectedIndex = 1
        let detailViewController = DetailViewController.createFromStoryboard(photoInfo: PhotoInfo(name: "", url: nil, size: CGSize()), index: expectedIndex + 1)!
        
        let result = sut.pageViewController(sut, viewControllerBefore: detailViewController) as! DetailViewController
        
        
        XCTAssertEqual(result.index, expectedIndex)
        XCTAssertEqual((result.viewModel as? DetailViewModel)?.photoInfo, viewModelStub.photoDatas[expectedIndex])
    }
    
    
    func testPageViewControllerViewControllerBefore_WhenNotExistIndexOnViewModel_ThenReturnNil() {
        let detailViewController = DetailViewController.createFromStoryboard(photoInfo: PhotoInfo(name: "", url: nil, size: CGSize()), index: 0)!
        
        let result = sut.pageViewController(sut, viewControllerBefore: detailViewController)
        
        XCTAssertNil(result)
    }
    
    
    func testPageViewControllerViewControllerAfter_ThenReturnNextViewController() {
        givenHasPhotoDatas()
        let expectedIndex = 3
        let detailViewController = DetailViewController.createFromStoryboard(photoInfo: PhotoInfo(name: "", url: nil, size: CGSize()), index: expectedIndex - 1)!
        
        let result = sut.pageViewController(sut, viewControllerAfter: detailViewController) as! DetailViewController
        
        
        XCTAssertEqual(result.index, expectedIndex)
        XCTAssertEqual((result.viewModel as? DetailViewModel)?.photoInfo, viewModelStub.photoDatas[expectedIndex])
    }
    
    
    func testPageViewControllerViewControllerAfter_WhenNotExistIndexOnViewModel_ThenReturnNil() {
        let detailViewController = DetailViewController.createFromStoryboard(photoInfo: PhotoInfo(name: "", url: nil, size: CGSize()), index: 5)!
        
        let result = sut.pageViewController(sut, viewControllerBefore: detailViewController)
        
        XCTAssertNil(result)
    }
}
