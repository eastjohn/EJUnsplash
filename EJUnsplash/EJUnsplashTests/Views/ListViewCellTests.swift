//
//  ListViewCellTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/11.
//

import XCTest
@testable import EJUnsplash

class ListViewCellTests: XCTestCase {
    private var sut: ListViewCell!

    override func setUpWithError() throws {
        sut = UICreator.createListCell()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    
    func testLoadView_ThenLoadedPhotoImageView() throws {
        XCTAssertNotNil(sut.photoImageView)
    }
    
    
    func testLoadView_ThenLoadedNameLabel() {
        XCTAssertNotNil(sut.nameLabel)
    }
    
    
    func testSetPhotoImage() {
        let expectedImage = UIImage()
        
        sut.photoImage = expectedImage
        
        XCTAssertTrue(sut.photoImageView.image === expectedImage)
    }

    
    func testSetPhotoImage_WhenNotLoadedPhtoImageView_ThenNotOccurFatalError() throws {
        sut.photoImageView = nil
        
        sut.photoImage = UIImage()
    }
    
    
    func testGetPhtoImage() {
        let expectedImage = UIImage()
        
        sut.photoImageView.image = expectedImage
        
        XCTAssertTrue(sut.photoImage === expectedImage)
    }
    
    
    func testGetPhotoImage_WhenNotLoadedPhotoImageView_ThenNotOccurFatalError() throws {
        sut.photoImageView = nil
        
        _ = sut.photoImage
    }
    
    
    func testSetName() {
        let expectedName = "testName"
        
        sut.name = expectedName
        
        XCTAssertEqual(sut.nameLabel.text, expectedName)
    }

    
    func testSetName_WhenNotLoadedNameLabel_ThenNotOccurFatalError() throws {
        sut.nameLabel = nil
        
        sut.name = ""
    }
    
    
    func testGetName() {
        let expectedName = "testName"
        
        sut.nameLabel.text = expectedName
        
        XCTAssertEqual(sut.nameLabel.text, expectedName)
    }
    
    
    func testGetName_WhenNotLoadedNameLabel_ThenNotOccurFatalError() throws {
        sut.nameLabel = nil
        
        _ = sut.name
    }
    
    
    func testPrepareForReuse_ThenClearAll() {
        sut.name = "test"
        sut.photoImage = UIImage()
        
        sut.prepareForReuse()
        
        XCTAssertNil(sut.name)
        XCTAssertNil(sut.photoImage)
    }
}
