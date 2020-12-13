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
        let expectedURL = URL(string: "http://test.com")
        let expectedIndex = 2
        
        let sut = DetailViewController.createFromStoryboard(url: expectedURL, index: expectedIndex)
        
        XCTAssertEqual((sut?.viewModel as? DetailViewModel)?.url, expectedURL)
        XCTAssertEqual(sut?.index, expectedIndex)
    }

}
