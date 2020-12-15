//
//  SearchViewControllerTests.swift
//  EJUnsplashTests
//
//  Created by 김요한 on 2020/12/14.
//

import XCTest
@testable import EJUnsplash

class SearchViewControllerTests: ListViewControllerTests {
    var searchViewController: SearchViewController!
    override var sut: ListViewController! {
        get {
            return searchViewController
        }
    }
    override func setUpWithError() throws {
        searchViewController = SearchViewController.createFromStoryboard()
    }
    
    override func tearDownWithError() throws {
        searchViewController = nil
    }

    
    
    // MARK: - Given
    override func givenHasViewModelSub() {
        super.givenHasViewModelSub()
        searchViewController.searchViewModel = viewModelStub
    }
    
    
    // MARK: - Tests
    func testLoadView_ThenLoadedHeaderView() throws {
        givenLoadedView()
        
        XCTAssertNotNil(searchViewController.headerView)
    }
    
    
    func testLoadView_ThenLoadedSearchBar() throws {
        givenLoadedView()
        
        XCTAssertNotNil(searchViewController.searchBar)
    }
    
    
    func testSetSearchBar_ThenSearchBarBackgroundImageIsEmptyImage() {
        let searchBar = UISearchBar()
        
        searchViewController.searchBar = searchBar
        
        XCTAssertEqual(searchBar.backgroundImage, UIImage())
    }

    
    func testViewDidLoad_ThenTableContentInsetTopIsSearchBarHeight() {
        givenLoadedView()
        
        searchViewController.viewDidLoad()
        
        XCTAssertEqual(searchViewController.tableView.contentInset.top, searchViewController.headerView.frame.height)
    }
    
    
    func testConfirmViewModel_WhenCreated() {
        XCTAssertTrue(searchViewController.viewModel is ListViewModel)
        XCTAssertTrue((searchViewController.viewModel as! ListViewModel).unsplashService is UnsplashSearchService)
    }
    
    
    func testSearchBarDelegateIsSearchViewController() {
        givenLoadedView()
        XCTAssertTrue(searchViewController.searchBar.delegate === searchViewController)
    }
    
    
    func testSearchBarSearchButtonClicked_WhenExistSearchText_ThenCallFetchDatasOfViewModel() {
        let expectedWasCalled = "called fetchDatas(query:)"
        givenHasViewModelSub()
        searchViewController.searchBar.text = "test"

        searchViewController.searchBarSearchButtonClicked(searchViewController.searchBar)


        XCTAssertTrue(viewModelStub.wasCalled.contains(expectedWasCalled))
        XCTAssertEqual(viewModelStub.paramQuery, searchViewController.searchBar.text)
    }
    
    
    func testSearchBarSearchButtonClicked_WhenNotExistSearchText_ThenCallFetchDatasOfViewModel() {
        let notCalled = "called fetchDatas(query:)"
        givenHasViewModelSub()

        searchViewController.searchBarSearchButtonClicked(searchViewController.searchBar)


        XCTAssertTrue(viewModelStub.wasCalled.contains(notCalled))
    }
    
    
    func testSearchBarSearchButtonClicked_ThenHideKeyboard() {
        givenHasPhotoDatasAndIncludeInWindow()
        searchViewController.searchBar.becomeFirstResponder()
        
        searchViewController.searchBarSearchButtonClicked(searchViewController.searchBar)
        
        XCTAssertFalse(searchViewController.searchBar.isFirstResponder)
    }
    
    
    func testSearchBarCancelButtonClicked_ThenDismiss() {
        let window = UIWindow()
        let parentViewController = MockViewController()
        window.addSubview(parentViewController.view)
        parentViewController.present(sut, animated: false, completion: nil)

        searchViewController.searchBarCancelButtonClicked(searchViewController.searchBar)

        XCTAssertTrue(parentViewController.wasCalled.contains("called dismiss(animated:completion:)"))
        XCTAssertTrue(parentViewController.paramAnimated)
    }
    
    
    func testViewDidLoad_ThenSearchBarFirstResponderIsTrue() {
        givenHasPhotoDatasAndIncludeInWindow()
        
        sut.viewDidLoad()
        
        XCTAssertTrue(searchViewController.searchBar.isFirstResponder)
    }


    func testBindPhotoDatas_ThenNotRetainCycle() {
        let notCalled = "called insertRows(at:with:)"
        let tableView = MockTableView()
        autoreleasepool { () -> () in
            searchViewController = SearchViewController()
            givenHasViewModelSub()
            let headerView = UIView()
            searchViewController.headerView = headerView
            searchViewController.tableView = tableView
            let searchBar = UISearchBar()
            searchViewController.searchBar = searchBar
            searchViewController.viewDidLoad()

            searchViewController = nil
        }
        viewModelStub.chagedHandler?(1..<10)


        XCTAssertFalse(tableView.wasCalled.contains(notCalled))
    }


    func testLoadView_ThenLoadedNoResultsViewAndHidden() {
        searchViewController.loadView()
        
        XCTAssertNotNil(searchViewController.noResultsView)
        XCTAssertTrue(searchViewController.noResultsView.isHidden)
    }
    
    
    func testChanagePhotoDatas_WhenPhotoDatasIsEmpty_ThenShowNoResultsView() {
        givenHasViewModelSub()
        searchViewController.viewDidLoad()
        
        viewModelStub.chagedHandler?(0..<0)

        XCTAssertFalse(searchViewController.noResultsView.isHidden)
    }
    
    
    func testChanagePhotoDatas_WhenPhotoDatasIsNotEmpty_ThenHideNoResultsView() {
        givenHasViewModelSub()
        searchViewController.viewDidLoad()
        searchViewController.noResultsView.isHidden = false
        
        viewModelStub.chagedHandler?(0..<1)

        XCTAssertTrue(searchViewController.noResultsView.isHidden)
    }

}
