//
//  MainViewControllerTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/10.
//

import XCTest
@testable import EJUnsplash

class MainViewControllerTests: XCTestCase {
    private var mainViewController: MainViewController!
    
    override func setUpWithError() throws {
        mainViewController = MainViewController.createViewController()
    }

    override func tearDownWithError() throws {
        mainViewController = nil
    }

    
    // MARK: - Given
    func givenLoadedView() {
        mainViewController.loadView()
    }
    
    func givenViewDidLoad() {
        givenLoadedView()
        mainViewController.viewDidLoad()
    }
    
    
    func testCreateViewController() throws {
        XCTAssertNotNil(mainViewController)
    }
    
    
    func testLoadView_ThenLoadedTableView() throws {
        givenLoadedView()
        
        XCTAssertNotNil(mainViewController.tableView)
    }
    
    
    func testLoadView_ThenLoadedStickyHeaderView() throws {
        givenLoadedView()
        
        XCTAssertNotNil(mainViewController.stickyHeaderView)
    }
    
    
    func testDataSourceOfTableViewIsMainViewController() {
        givenLoadedView()
        
        XCTAssertTrue(mainViewController.tableView.dataSource === mainViewController)
    }
    
    
    func testDelegateOfTableViewIsMainViewController() {
        givenLoadedView()
        
        XCTAssertTrue(mainViewController.tableView.delegate === mainViewController)
    }

    
    func testViewDidLoad_ThenTableContentInsetTopIsStickyHeaderViewHeight() {
        givenLoadedView()
        
        mainViewController.viewDidLoad()
        
        XCTAssertEqual(mainViewController.tableView.contentInset.top, mainViewController.stickHeaderViewHeightConstraint.constant)
    }
    
    
    func testScrollViewDidChange_WhenContentYOffsetIsLessThanMinHeightOfStickyHeaderView_ThenChangeHeightContraintOfStickyHeaderView() {
        givenViewDidLoad()
        let expectedHeight: CGFloat = -100
        let scrollView = UIScrollView()
        scrollView.contentOffset.y = expectedHeight
        
        mainViewController.scrollViewDidScroll(scrollView)
        
        XCTAssertEqual(mainViewController.stickHeaderViewHeightConstraint.constant, -expectedHeight)
    }
    
    
    func testScrollViewDidChange_WhenContentYOffsetIsGreaterThanMinHeightOfStickyHeaderView_ThenHeightContraintOfStickyHeaderViewIsMinHeight() {
        givenViewDidLoad()
        let scrollView = UIScrollView()
        scrollView.contentOffset.y = 150
        
        mainViewController.scrollViewDidScroll(scrollView)
        
        XCTAssertEqual(mainViewController.stickHeaderViewHeightConstraint.constant, MainViewController.stickyHeaderViewMinHeight)
    }
}
