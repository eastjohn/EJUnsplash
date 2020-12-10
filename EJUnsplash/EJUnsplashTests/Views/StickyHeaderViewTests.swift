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
    
    override func setUpWithError() throws {
        sut = MainViewController.createStickyHeaderView()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

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
}
