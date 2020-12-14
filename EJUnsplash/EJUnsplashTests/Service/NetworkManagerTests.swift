//
//  NetworkManagerTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/13.
//

import XCTest
@testable import EJUnsplash

class NetworkManagerTests: XCTestCase {
    private var sut: NetworkManager!
    private var session: MockURLSession!
    
    override func setUpWithError() throws {
        sut = NetworkManager()
        session = MockURLSession()
        sut.session = session
    }

    override func tearDownWithError() throws {
        sut = nil
        session = nil
    }

    
    func testConfirmURLSession_WhenCreated() throws {
        sut = NetworkManager()
        XCTAssertEqual(sut.session, URLSession.shared)
    }

    
    func testSendRequest_ThenCallDataTaskOfSessionAndResume() {
        let expectedWasCalled = "called dataTask(with:completionHandler:)"
        let request = UnsplashRequest(api: .list, parameters: [.page:"1"])
        
        sut.sendRequest(request) { _, _ in }
        
        XCTAssertTrue(session.wasCalled.contains(expectedWasCalled))
        XCTAssertEqual(request.createURLRequest(), session.paramRequest)
        XCTAssertTrue(session.dataTask!.wasCalled.contains("called resume()"))
    }
    
    
    func whenSendRequest_ThenCallCompletionHandler(data: Data?, error: Error?, expectedData: Data?, expectedError: NSError?) {
        let request = UnsplashRequest(api: .list, parameters: [.page:"1"])
        let expection = expectation(description: "receiveData")
        
        sut.sendRequest(request) { data, error in
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertEqual(data, expectedData)
            XCTAssertEqual(error as NSError?, expectedError)
            expection.fulfill()
        }
        
        DispatchQueue.global().async {
            self.session.dataTask?.completionHandler(data, nil, error)
        }
        
        wait(for: [expection], timeout: 2)
    }
    
    
    func testSendRequest_WhenReceiveData_ThenCallCompletionHandler() {
        let expectedData = Data(base64Encoded: "test")

        whenSendRequest_ThenCallCompletionHandler(data: expectedData, error: nil, expectedData: expectedData, expectedError: nil)
    }
    
    
    func testSendRequest_WhenReceiveError_ThenCallCompletionHandler() {
        let expectedError = NSError(domain: "test", code: 100, userInfo: nil)
        let data = Data()
        
        whenSendRequest_ThenCallCompletionHandler(data: data, error: expectedError, expectedData: nil, expectedError: expectedError)
    }
    
    
    func testSendDownloadRequest_ThenCallDataTaskOfSessionAndResume() {
        let expectedURL = URL(string: "http://test.com")!
        let expectedWasCalled = "called dataTask(with:completionHandler:)"
        
        sut.sendDownloadRequest(url: expectedURL) { _, _ in }
        
        XCTAssertTrue(session.wasCalled.contains(expectedWasCalled))
        XCTAssertEqual(session.paramURL, expectedURL)
        XCTAssertTrue(session.dataTask!.wasCalled.contains("called resume()"))
    }
    
    
    func testSendDownlaodRequest_WhenReceiveData_ThenCallCompletionHandler() {
        let expectedData = Data(base64Encoded: "test")
        let expectedError = NSError(domain: "test", code: -1, userInfo: nil)
        
        var wasCalled = false
        sut.sendDownloadRequest(url: URL(string: "http://test.com")!) { data, error in
            XCTAssertEqual(data, expectedData)
            XCTAssertEqual(error as NSError?, expectedError)
            wasCalled = true
        }
        
        self.session.dataTask?.completionHandler(expectedData, nil, expectedError)
        
        XCTAssertTrue(wasCalled)
    }
}
