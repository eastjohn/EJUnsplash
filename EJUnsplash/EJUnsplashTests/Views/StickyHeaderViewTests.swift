//
//  StickyHeaderViewTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/11.
//

import XCTest
@testable import EJUnsplash

class StickyHeaderViewTests: XCTestCase {
    private var sut: StickyHeaderView!
    private var viewModelStub: StickyHeaderViewModelStub!
    
    override func setUpWithError() throws {
        sut = UICreator.createStickyHeaderView()
        viewModelStub = StickyHeaderViewModelStub()
    }

    override func tearDownWithError() throws {
        sut = nil
        viewModelStub = nil
    }
    
    
    // MARK: - Given
    func givenViewModelStub() {
        sut = StickyHeaderView()
        sut.viewModel = viewModelStub
    }
    

    // MARK: - Tests
    func testCreateView() throws {
        XCTAssertNotNil(sut)
    }
    
    
    func testLoadView_ThenBackgroundImageViewIsNotNil() {
        XCTAssertNotNil(sut.backgroundImageView)
    }
    
    
    func testLoadView_ThenSearchBarIsNotNil() {
        XCTAssertNotNil(sut.searchBar)
    }
    
    
    func testSetSearchBar_ThenSearchBarBackgroundImageIsEmptyImage() {
        let searchBar = UISearchBar()
        
        sut.searchBar = searchBar
        
        XCTAssertEqual(searchBar.backgroundImage, UIImage())
    }
    
    
    func testLayoutSubviews_WhenHeghitIsMaxHeight_ThenBackgroundImageViewAlphaIs1() {
        sut.frame.size.height = StickyHeaderView.MaxHeight
        
        sut.layoutSubviews()
        
        XCTAssertEqual(sut.backgroundImageView.alpha, 1.0)
    }
    
    
    func testLayoutSubviews_WhenHeghitIsHalfMaxHeight_ThenChagedBackgroundImageViewAlpha() {
        sut.frame.size.height = StickyHeaderView.MaxHeight / 2
        
        sut.layoutSubviews()
        
        XCTAssertEqual(sut.backgroundImageView.alpha,
                       (sut.frame.size.height - StickyHeaderView.MinHeight) / (StickyHeaderView.MaxHeight - StickyHeaderView.MinHeight),
                       accuracy: 0.0001)
    }
    
    func testLayoutSubviews_WhenHeghitIsMinHeight_ThenBackgroundImageViewAlphaIsZero() {
        sut.frame.size.height = StickyHeaderView.MinHeight
        
        sut.layoutSubviews()
        
        
        XCTAssertEqual(sut.backgroundImageView.alpha, 0)
    }
    
    
    func testExistViewModel_WhenCreated() {
        XCTAssertTrue(sut.viewModel is StickyHeaderViewModel)
    }
    
    
    func testSetBackgroundImageView_ThenBindViewModel() {
        let expectedImage = UIImage()
        let imageView = UIImageView()
        givenViewModelStub()


        sut.backgroundImageView = imageView
        viewModelStub.updateImage(expectedImage)


        XCTAssertEqual(imageView.image, expectedImage)
    }
    
    
    func testBind_WhenSutIsNil_ThenNotRetainCycle() {
        givenViewModelStub()
        let imageView = UIImageView()
        sut.backgroundImageView = imageView
        
        sut = nil
        viewModelStub.updateImage(UIImage())
        
        
        XCTAssertNil(imageView.image)
    }
}
