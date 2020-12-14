//
//  ListPreseningAnimatorTests.swift
//  EJUnsplashTests
//
//  Created by 김요한 on 2020/12/14.
//

import XCTest
@testable import EJUnsplash

class ListPreseningAnimatorTests: XCTestCase {
    private var sut: ListPresentingAnimator!

    override func setUpWithError() throws {
        sut = ListPresentingAnimator()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testConfirmDuration_WhenCreated() throws {
        XCTAssertEqual(sut.duration, 0.3)
    }
    
    
    func testTransitionDuration_ThenReturnDuration() {
        let result = sut.transitionDuration(using: nil)
        
        XCTAssertEqual(result, sut.duration)
    }
    
    
    func testAnimateTransition_ThenAnimateTargetView() {
        let context = MockControllerContext()
        let expectation = self.expectation(description: "transitionAnimation")
        context.expectation = expectation
        let finalFrame = context.toView.frame
        let expectedWasCalled = "called layoutIfNeeded()"
        sut.originalFrame = CGRect(x: 20, y: 30, width: 100, height: 200)
        let window = UIWindow()
        window.addSubview(context.containerView)
        
        var count = 0
        context.toView.completionHandler = { [weak self] in
            guard let self = self else { fatalError() }
            guard count == 0 else { return }
            count += 1
            XCTAssertEqual(context.toView.frame, self.sut.originalFrame)
            XCTAssertEqual(context.toView.backgroundColor, UIColor(white: 0, alpha: 0))
            XCTAssertEqual(context.containerView.subviews[0], context.toView)
            XCTAssertTrue(context.toView.wasCalled.contains(expectedWasCalled))
            context.toView.wasCalled = ""
        }
        
        
        sut.animateTransition(using: context)
        

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(context.toView.frame, finalFrame)
        XCTAssertEqual(context.toView.backgroundColor, UIColor(white: 0, alpha: 1))
        XCTAssertTrue(context.toView.wasCalled.contains(expectedWasCalled))
    }

}
