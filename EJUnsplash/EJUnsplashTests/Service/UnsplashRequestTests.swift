//
//  UnsplashRequestTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/13.
//

import XCTest
@testable import EJUnsplash

class UnsplashRequestTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    
    func testCreateURLRequestForList() throws {
        let expectedURLPath = "https://api.unsplash.com/photos?page=1&per_page=10"
        let sut = UnsplashRequest(api: .list, parameters: [.page:"1", .per_page:"10"])
        
        let result = sut.createURLRequest()
        
        checkURL(url1: result!.url!.absoluteString, url2: expectedURLPath)
        XCTAssertEqual(result?.allHTTPHeaderFields?["Authorization"], "Client-ID \(UnsplashAccessKey.key)")
    }
    
    
    func testCreateURLRequestForRandom() {
        let expectedURLPath = "https://api.unsplash.com/photos/random?count=3"
        let sut = UnsplashRequest(api: .random, parameters: [.count:"3"])
        
        let result = sut.createURLRequest()
        
        XCTAssertEqual(result?.url?.absoluteString, expectedURLPath)
        XCTAssertEqual(result?.allHTTPHeaderFields?["Authorization"], "Client-ID \(UnsplashAccessKey.key)")
    }
    
    
    func testCreateURLRequestForSearch() {
        let expectedURLPath = "https://api.unsplash.com/search/photos?query=test&page=1&per_page=10"
        let sut = UnsplashRequest(api: .search, parameters: [.query:"test", .page:"1", .per_page: "10"])
        
        let result = sut.createURLRequest()
        
        checkURL(url1: result!.url!.absoluteString, url2: expectedURLPath)
        XCTAssertEqual(result?.allHTTPHeaderFields?["Authorization"], "Client-ID \(UnsplashAccessKey.key)")
    }
    
    
    func checkURL(url1: String, url2: String) {
        let component1 = url1.split(separator: "?")
        let component2 = url2.split(separator: "?")
        XCTAssertEqual(component1.first, component2.first)
        
        let set1 = Set( component1.last!.split(separator: "&") )
        let set2 = Set( component1.last!.split(separator: "&") )
        XCTAssertEqual(set1, set2)
    }
}
