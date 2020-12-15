//
//  MainViewControllerTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/10.
//

import XCTest
@testable import EJUnsplash

class MainViewControllerTests: ListViewControllerTests {
    var mainViewController: MainViewController!
    override var sut: ListViewController! {
        get {
            return mainViewController
        }
    }
    
    override func setUpWithError() throws {
        mainViewController = UICreator.createMainViewController()
    }
    
    override func tearDownWithError() throws {
        mainViewController = nil
    }


    
    // MARK: - Given
    func givenViewDidLoad() {
        givenLoadedView()
        mainViewController.viewDidLoad()
    }
    
    
    override func givenHasViewModelSub() {
        super.givenHasViewModelSub()
        mainViewController.mainViewModel = viewModelStub
    }
    
    
    // MARK: - Tests
    func testLoadView_ThenLoadedStickyHeaderView() throws {
        givenLoadedView()
        
        XCTAssertNotNil(mainViewController.stickyHeaderView)
    }

    
    func testViewDidLoad_ThenTableContentInsetTopIsStickyHeaderViewHeight() {
        givenLoadedView()
        
        mainViewController.viewDidLoad()
        
        XCTAssertEqual(sut.tableView.contentInset.top, mainViewController.stickHeaderViewHeightConstraint.constant)
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
        
        XCTAssertEqual(mainViewController.stickHeaderViewHeightConstraint.constant, StickyHeaderView.MinHeight)
    }
    
    
    func testConfirmViewModel_WhenCreated() {
        XCTAssertTrue(mainViewController.viewModel is ListViewModel)
        XCTAssertTrue((mainViewController.viewModel as! ListViewModel).unsplashService is UnsplashListService)
    }
    
    
    func testViewDidLoad_ThenCallFetchDatasOfViewModel() {
        let expectedWasCalled = "called fetchDatas()"
        givenHasViewModelSub()
        
        
        mainViewController.viewDidLoad()
        
        
        XCTAssertTrue(viewModelStub.wasCalled.contains(expectedWasCalled))
    }
    
    
    func testBindPhotoDatas_ThenNotRetainCycle() {
        let notCalled = "called insertRows(at:with:)"
        let tableView = MockTableView()
        autoreleasepool { () -> () in
            mainViewController = MainViewController()
            givenHasViewModelSub()
            mainViewController.tableView = tableView
            let consraint = NSLayoutConstraint()
            mainViewController.stickHeaderViewHeightConstraint = consraint
            mainViewController.viewDidLoad()
            
            mainViewController = nil
        }
        viewModelStub.chagedHandler?(1..<10)
        
        
        XCTAssertFalse(tableView.wasCalled.contains(notCalled))
    }
    
    
    func testSearchBarDelegateIsMainViewController() {
        givenLoadedView()
        
        XCTAssertTrue(mainViewController.stickyHeaderView.searchBar.delegate === mainViewController)
    }
    
    
    func testSearchBarTouched_ThenPresentSearchViewController() {
        givenHasPhotoDatasAndIncludeInWindow()
        
        _ = mainViewController.searchBarShouldBeginEditing(mainViewController.stickyHeaderView.searchBar)
        
        XCTAssertTrue(sut.presentedViewController is SearchViewController)
    }
    
    
    func testSearchBarShouldBeginEditing_ThenReturnFalse() {
        givenLoadedView()
        XCTAssertFalse(mainViewController.searchBarShouldBeginEditing(mainViewController.stickyHeaderView.searchBar))
    }
}
