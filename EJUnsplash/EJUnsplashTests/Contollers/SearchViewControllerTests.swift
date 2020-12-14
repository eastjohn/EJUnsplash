//
//  SearchViewControllerTests.swift
//  EJUnsplashTests
//
//  Created by 김요한 on 2020/12/14.
//

import XCTest
@testable import EJUnsplash

class SearchViewControllerTests: XCTestCase {
    private var sut: SearchViewController!
    private var viewModelStub: ListViewModelStub!
    private var window: UIWindow!

    
    override func setUpWithError() throws {
        sut = SearchViewController.createFromStoryboard()
        window = nil
    }

    override func tearDownWithError() throws {
        sut = nil
        viewModelStub = nil
    }

    
    func testCreate() throws {
        let sut = SearchViewController.createFromStoryboard()
        
        XCTAssertNotNil(sut)
    }
    
    
    // MARK: - Given
    func givenLoadedView() {
        sut.loadView()
    }
    
    
    func givenHasViewModelSub() {
        givenLoadedView()
        viewModelStub = ListViewModelStub()
        sut.viewModel = viewModelStub
    }
    
    
    func givenHasPhotoDatasAndIncludeInWindow(count: Int = 3) {
        givenLoadedView()
        let viewModel = sut.viewModel as! ListViewModel
        for index in 0..<count {
            viewModel.photoDatas.append(PhotoInfo(name: "test\(index)", url: nil, size: CGSize(width: 400, height: 300)))
        }
        window = UIWindow()
        window.isHidden = false
        window.addSubview(sut.view)
    }
    
    
    // MARK: - Tests
    func testLoadView_ThenLoadedTableView() throws {
        givenLoadedView()
        
        XCTAssertNotNil(sut.tableView)
    }
    
    
    func testLoadView_ThenLoadedHeaderView() throws {
        givenLoadedView()
        
        XCTAssertNotNil(sut.headerView)
    }
    
    
    func testLoadView_ThenLoadedSearchBar() throws {
        givenLoadedView()
        
        XCTAssertNotNil(sut.searchBar)
    }
    
    
    func testSetSearchBar_ThenSearchBarBackgroundImageIsEmptyImage() {
        let searchBar = UISearchBar()
        
        sut.searchBar = searchBar
        
        XCTAssertEqual(searchBar.backgroundImage, UIImage())
    }
    
        
    func testDataSourceOfTableViewIsMainViewController() {
        givenLoadedView()
        
        XCTAssertTrue(sut.tableView.dataSource === sut)
    }
    
    
    func testDelegateOfTableViewIsMainViewController() {
        givenLoadedView()
        
        XCTAssertTrue(sut.tableView.delegate === sut)
    }
    
    
    func testPrefetchDataSourceOfTableViewIsMainViewController() {
        givenLoadedView()
        
        XCTAssertTrue(sut.tableView.prefetchDataSource === sut)
    }

    
    func testViewDidLoad_ThenTableContentInsetTopIsSearchBarHeight() {
        givenLoadedView()
        
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.tableView.contentInset.top, sut.headerView.frame.height)
    }
    
    
    func testConfirmViewModel_WhenCreated() {
        XCTAssertTrue(sut.viewModel is ListViewModel)
        XCTAssertTrue((sut.viewModel as! ListViewModel).unsplashService is UnsplashSearchService)
    }
    
    
    func testSearchBarDelegateIsSearchViewController() {
        givenLoadedView()
        XCTAssertTrue(sut.searchBar.delegate === sut)
    }
    
    
    func testSearchBarSearchButtonClicked_WhenExistSearchText_ThenCallFetchDatasOfViewModel() {
        let expectedWasCalled = "called fetchDatas(query:)"
        givenHasViewModelSub()
        sut.searchBar.text = "test"

        sut.searchBarSearchButtonClicked(sut.searchBar)


        XCTAssertTrue(viewModelStub.wasCalled.contains(expectedWasCalled))
        XCTAssertEqual(viewModelStub.paramQuery, sut.searchBar.text)
    }
    
    
    func testSearchBarSearchButtonClicked_WhenNotExistSearchText_ThenCallFetchDatasOfViewModel() {
        let notCalled = "called fetchDatas(query:)"
        givenHasViewModelSub()

        sut.searchBarSearchButtonClicked(sut.searchBar)


        XCTAssertTrue(viewModelStub.wasCalled.contains(notCalled))
    }
    
    
    func testSearchBarSearchButtonClicked_ThenHideKeyboard() {
        givenHasPhotoDatasAndIncludeInWindow()
        sut.searchBar.becomeFirstResponder()
        
        sut.searchBarSearchButtonClicked(sut.searchBar)
        
        XCTAssertFalse(sut.searchBar.isFirstResponder)
    }
    
    
    func testSearchBarCancelButtonClicked_ThenDismiss() {
        let window = UIWindow()
        let parentViewController = MockViewController()
        window.addSubview(parentViewController.view)
        parentViewController.present(sut, animated: false, completion: nil)

        sut.searchBarCancelButtonClicked(sut.searchBar)

        XCTAssertTrue(parentViewController.wasCalled.contains("called dismiss(animated:completion:)"))
        XCTAssertTrue(parentViewController.paramAnimated)
    }
    
    
    func testViewDidLoad_ThenSearchBarFirstResponderIsTrue() {
        givenHasPhotoDatasAndIncludeInWindow()
        
        sut.viewDidLoad()
        
        XCTAssertTrue(sut.searchBar.isFirstResponder)
    }


    func testViewDidLoad_ThenCallBindPhotoDatasOfViewModel() {
        let expectedWasCalled = "called bindPhotoDatas(changedHandler:)"
        givenHasViewModelSub()


        sut.viewDidLoad()


        XCTAssertTrue(viewModelStub.wasCalled.contains(expectedWasCalled))
    }


    func testChanagePhotoDatas_WhenTableRowIsZero_ThenReloadTableView() {
        let expectedWasCalled = "called reloadData()"
        givenHasViewModelSub()
        sut.viewDidLoad()
        let tableView = MockTableView()
        sut.tableView = tableView


        viewModelStub.chagedHandler?(0..<10)


        XCTAssertTrue(tableView.wasCalled.contains(expectedWasCalled))
    }


    func testChanagePhotoDatas_WhenTableRowIsGreaterThanZero_ThenInsertRowsToTableView() {
        let expectedWasCalled = "called insertRows(at:with:)"
        givenHasViewModelSub()
        sut.viewDidLoad()
        let tableView = MockTableView()
        sut.tableView = tableView
        let range = 1..<10
        let expectedIndexPaths = range.map { IndexPath(row: $0, section: 0) }


        viewModelStub.chagedHandler?(range)


        XCTAssertTrue(tableView.wasCalled.contains(expectedWasCalled))
        XCTAssertEqual(tableView.paramIndexPaths, expectedIndexPaths)
    }


    func testBindPhotoDatas_ThenNotRetainCycle() {
        let notCalled = "called insertRows(at:with:)"
        let tableView = MockTableView()
        autoreleasepool { () -> () in
            sut = SearchViewController()
            givenHasViewModelSub()
            let headerView = UIView()
            sut.headerView = headerView
            sut.tableView = tableView
            let searchBar = UISearchBar()
            sut.searchBar = searchBar
            sut.viewDidLoad()

            sut = nil
        }
        viewModelStub.chagedHandler?(1..<10)


        XCTAssertFalse(tableView.wasCalled.contains(notCalled))
    }

    
    func testTableViewNumberOfRowsInSection_ThenReturnDataCountOfViewModel() {
        givenHasViewModelSub()

        XCTAssertEqual(sut.tableView(sut.tableView, numberOfRowsInSection: 0), viewModelStub.dataCount)
    }


    func testTableViewCellForRowAt_ThenReturnListViewCell() {
        givenHasViewModelSub()
        let tableView = MockTableView()
        let expectedIndexPath = IndexPath(row: 0, section: 0)

        let cell = sut.tableView(tableView, cellForRowAt: expectedIndexPath)


        XCTAssertEqual(tableView.paramIndexPath, expectedIndexPath)
        XCTAssertEqual(tableView.paramIdentifier, ListViewCell.Identifier)
        XCTAssertEqual(cell, tableView.returnCell)
    }


    func testTableViewCellForRowAt_ConfirmRegisterCellStoryboard() {
        givenHasViewModelSub()

        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cell is ListViewCell)
    }


    func testTableViewCellForRowAt_ThenCallUpdateImageInfoOfViewModel() {
        let expectedWasCalled = "called updatePhotoInfo(for:updateHandler:completionLoadedPhotoImageHandler:)"
        let expectedIndexPath = IndexPath(row: 2, section: 0)
        let tableView = MockTableView()
        givenHasViewModelSub()


        _ = sut.tableView(tableView, cellForRowAt: expectedIndexPath)


        XCTAssertTrue(viewModelStub.wasCalled.contains(expectedWasCalled))
        XCTAssertEqual(viewModelStub.paramIndexPath, expectedIndexPath)
        XCTAssertEqual(tableView.returnCell.name, viewModelStub.photoInfo.name)
        XCTAssertTrue(tableView.returnCell.photoImage === viewModelStub.photoImage)
    }


    func testTableViewPrefetchRowsAt_ThenCallPrefetchRowsAtOfViewModel() {
        let expectedWasCalled = "called prefetchRowsAt(indexPaths:)"
        let expectedIndexPaths = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)]
        givenHasViewModelSub()


        sut.tableView(sut.tableView, prefetchRowsAt: expectedIndexPaths)


        XCTAssertTrue(viewModelStub.wasCalled.contains(expectedWasCalled))
        XCTAssertEqual(viewModelStub.paramIndexPaths, expectedIndexPaths)
    }


    func testTableViewCancelPrefetchingForRowsAt_ThenCallCancelPrefetchingForRowsAtOfViewModel() {
        let expectedWasCalled = "called cancelPrefetchingForRowsAt(indexPaths:)"
        let expectedIndexPaths = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)]
        givenHasViewModelSub()


        sut.tableView(sut.tableView, cancelPrefetchingForRowsAt: expectedIndexPaths)


        XCTAssertTrue(viewModelStub.wasCalled.contains(expectedWasCalled))
        XCTAssertEqual(viewModelStub.paramIndexPaths, expectedIndexPaths)
    }


    func testTableViewDidEndDisplayingAt_ThenCallDidEndDisplayingAtForRowsAtOfViewModel() {
        let expectedWasCalled = "called didEndDisplayingAt(indexPath:)"
        let expectedIndexPath = IndexPath(row: 1, section: 0)
        givenHasViewModelSub()


        sut.tableView(sut.tableView, didEndDisplaying: UITableViewCell(), forRowAt: expectedIndexPath)


        XCTAssertTrue(viewModelStub.wasCalled.contains(expectedWasCalled))
        XCTAssertEqual(viewModelStub.paramIndexPath, expectedIndexPath)
    }


    func testTableViewHeightForRowAt_ThenReturnCellHeight() {
        givenHasViewModelSub()
        let expectedWasCalled = "called photoImageSizeForRowAt(indexPath:)"
        let expectedIndexPath = IndexPath(row: 2, section: 0)
        let expectedHeight = viewModelStub.photoImageSize.height / viewModelStub.photoImageSize.width * sut.tableView.frame.width

        let result = sut.tableView(sut.tableView, heightForRowAt: expectedIndexPath)

        XCTAssertEqual(result, expectedHeight)
        XCTAssertEqual(viewModelStub.paramIndexPath, expectedIndexPath)
        XCTAssertTrue(viewModelStub.wasCalled.contains(expectedWasCalled))
    }


    func testTableViewDidSelectRowAt_ThenPresentPageViewController() {
        givenHasPhotoDatasAndIncludeInWindow()
        let expectedIndexPath = IndexPath(row: 2, section: 0)
        let viewModel = sut.viewModel as! ListViewModel

        sut.tableView(sut.tableView, didSelectRowAt: expectedIndexPath)

        let pageViewController = sut.presentedViewController as! PageViewController
        XCTAssertTrue((pageViewController.viewModel as? PageViewModel)?.unsplashService === viewModel.unsplashService)
        XCTAssertEqual((pageViewController.viewModel as? PageViewModel)?.photoDatas, viewModel.photoDatas)
        XCTAssertEqual(pageViewController.selectedIndex, expectedIndexPath.row)
        XCTAssertTrue(pageViewController.transitioningDelegate === sut)
    }


    func testAnimationControllerForPresented_ThenReturnListPresentingAnimator() {
        givenHasPhotoDatasAndIncludeInWindow()
        let pageViewController = PageViewController.createFromStoryboard(unsplashService: UnsplashServiceStub())!
        let indexPath = IndexPath(row: 1, section: 0)
        sut.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
        let selectedCell = sut.tableView.cellForRow(at: indexPath)!
        let expectedOriginalFrame = selectedCell.superview!.convert(selectedCell.frame, to: nil)


        let result = sut.animationController(forPresented: pageViewController, presenting: sut, source: sut)

        XCTAssertTrue(result is ListPresentingAnimator)
        XCTAssertEqual((result as? ListPresentingAnimator)?.originalFrame, expectedOriginalFrame)
    }


    func testPageViewControllerDismiss_ThenChangeScrollOfTableView() {
        givenHasPhotoDatasAndIncludeInWindow(count: 20)
        sut.tableView.reloadData()
        let index = 15
        let pageViewController = PageViewController.createFromStoryboard(unsplashService: UnsplashServiceStub())!
        let detailViewController = DetailViewController.createFromStoryboard(photoInfo: PhotoInfo(name: "", url: nil, size: CGSize()), index: index)!
        pageViewController.setViewControllers([detailViewController], direction: .forward, animated: false, completion: nil)
        sut.present(pageViewController, animated: false, completion: nil)


        sut.dismiss(animated: false, completion: nil)


        let cell = sut.tableView.cellForRow(at: IndexPath(row: index, section: 0))!
        XCTAssertEqual(sut.tableView.contentOffset.y, cell.frame.minY - (sut.tableView.frame.height - cell.frame.height) / 2, accuracy: 0.1)
    }


    func testLoadView_ThenLoadedNoResultsViewAndHidden() {
        sut.loadView()
        
        XCTAssertNotNil(sut.noResultsView)
        XCTAssertTrue(sut.noResultsView.isHidden)
    }
    
    
    func testChanagePhotoDatas_WhenPhotoDatasIsEmpty_ThenShowNoResultsView() {
        givenHasViewModelSub()
        sut.viewDidLoad()
        
        viewModelStub.chagedHandler?(0..<0)

        XCTAssertFalse(sut.noResultsView.isHidden)
    }
    
    
    func testChanagePhotoDatas_WhenPhotoDatasIsNotEmpty_ThenHideNoResultsView() {
        givenHasViewModelSub()
        sut.viewDidLoad()
        sut.noResultsView.isHidden = false
        
        viewModelStub.chagedHandler?(0..<1)

        XCTAssertTrue(sut.noResultsView.isHidden)
    }

}
