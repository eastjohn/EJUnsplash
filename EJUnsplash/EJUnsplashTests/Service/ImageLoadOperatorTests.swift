//
//  ImageLoadOperatorTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/12.
//

import XCTest
@testable import EJUnsplash

class ImageLoadOperatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testCreateImageLoadOperator() throws {
        let expectedURL = URL(string: "http://www.test.com")
        var wasCalled = false
        
        let sut = ImageLoadOperator(url: expectedURL) { _ in
            wasCalled = true
        }
        sut.completionHandler?(UIImage())
        
        XCTAssertEqual(sut.url, expectedURL)
        XCTAssertTrue(wasCalled)
    }

}
