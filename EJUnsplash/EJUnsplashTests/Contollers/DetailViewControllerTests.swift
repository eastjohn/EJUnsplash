//
//  DetailViewControllerTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/13.
//

import XCTest
@testable import EJUnsplash

class DetailViewControllerTests: XCTestCase {
    private var sut: DetailViewController!
    private var viewModelStub: DetailViewModelStub!

    override func setUpWithError() throws {
        sut = DetailViewController.createFromStoryboard(photoInfo: PhotoInfo(name: "test", url: URL(string: "http://test.com"), size: CGSize()), index: 2)
        givenLoadedView()
        viewModelStub = DetailViewModelStub()
    }

    
    override func tearDownWithError() throws {
        sut = nil
        viewModelStub = nil
    }
    
    // MARK: - Given
    func givenLoadedView() {
        sut.loadView()
    }
    
    
    func givenHasDetailViewMolelStub() {
        sut.viewModel = viewModelStub
    }
    

    // MARK: - Tests
    func testCreateViewController() throws {
        let expectedPhotoInfo = PhotoInfo(name: "test", url: nil, size: CGSize())
        let expectedIndex = 2
        
        let sut = DetailViewController.createFromStoryboard(photoInfo: expectedPhotoInfo, index: expectedIndex)
        
        XCTAssertEqual((sut?.viewModel as? DetailViewModel)?.photoInfo, expectedPhotoInfo)
        XCTAssertEqual(sut?.index, expectedIndex)
    }
    
    
    func testLoadView_ThenLoadedTitleLabel() {
        XCTAssertNotNil(sut.titleLabel)
    }
    
    
    func testLoadView_ThenLoadedImageView() {
        XCTAssertNotNil(sut.imageView)
    }
    
    
    func testViewDidLoad_ThenSetTitle() {
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.titleLabel.text, (sut.viewModel as? DetailViewModel)?.photoInfo.name)
    }
    
    
    func testViewDidLoad_ThenBindPhotoImageOfViewModel() {
        let expectedWasCalled = "called bindPhotoImage(completionHandler:)"
        givenHasDetailViewMolelStub()
        
        sut.viewDidLoad()
        
        XCTAssertTrue(viewModelStub.wasCalled.contains(expectedWasCalled))
    }
    
    
    func testReceiveImage_ThenUpdateImageOfImageView() {
        givenHasDetailViewMolelStub()
        sut.viewDidLoad()
        let expectedImage = UIImage()
        
        viewModelStub.completionHandler?(expectedImage)
        
        XCTAssertTrue(sut.imageView.image === expectedImage)
    }
    
    
    func testViewDidLoad_ThenNotRetainCycle() {
        sut = DetailViewController()
        let label = UILabel()
        sut.titleLabel = label
        givenHasDetailViewMolelStub()
        weak var weakSut = sut
        
        sut.viewDidLoad()
        sut = nil
        
        XCTAssertNil(weakSut)
    }

}
