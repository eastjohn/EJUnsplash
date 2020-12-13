//
//  DetailViewControllerTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/13.
//

import XCTest
@testable import EJUnsplash

class DetailViewControllerTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testCreateViewController() throws {
        let expectedPhotoInfo = PhotoInfo(name: "test", url: nil, size: CGSize())
        let expectedIndex = 2
        
        let sut = DetailViewController.createFromStoryboard(photoInfo: expectedPhotoInfo, index: expectedIndex)
        
        XCTAssertEqual((sut?.viewModel as? DetailViewModel)?.photoInfo, expectedPhotoInfo)
        XCTAssertEqual(sut?.index, expectedIndex)
    }
    
    
    func testLoadView_ThenLoadedTitleLabel() {
        
    }

}
