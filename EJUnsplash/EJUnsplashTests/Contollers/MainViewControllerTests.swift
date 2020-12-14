//
//  MainViewControllerTests.swift
//  EJUnsplashTests
//
//  Created by John on 2020/12/10.
//

import XCTest
@testable import EJUnsplash

class MainViewControllerTests: XCTestCase {
    private var sut: MainViewController!
    private var viewModelStub: ListViewModelStub!
    private var window: UIWindow!
    
    override func setUpWithError() throws {
        sut = UICreator.createMainViewController()
        viewModelStub = ListViewModelStub()
    }

    override func tearDownWithError() throws {
        sut = nil
        viewModelStub = nil
        window = nil
    }

    
    // MARK: - Given
    func givenLoadedView() {
        sut.loadView()
    }
    
    func givenViewDidLoad() {
        givenLoadedView()
        sut.viewDidLoad()
    }
    
    
    func givenHasViewModelSub() {
        givenLoadedView()
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
    func testCreateViewController() throws {
        XCTAssertNotNil(sut)
    }
    
    
    func testLoadView_ThenLoadedTableView() throws {
        givenLoadedView()
        
        XCTAssertNotNil(sut.tableView)
    }
    
    
    func testLoadView_ThenLoadedStickyHeaderView() throws {
        givenLoadedView()
        
        XCTAssertNotNil(sut.stickyHeaderView)
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

    
    func testViewDidLoad_ThenTableContentInsetTopIsStickyHeaderViewHeight() {
        givenLoadedView()
        
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.tableView.contentInset.top, sut.stickHeaderViewHeightConstraint.constant)
    }
    
    
    func testScrollViewDidChange_WhenContentYOffsetIsLessThanMinHeightOfStickyHeaderView_ThenChangeHeightContraintOfStickyHeaderView() {
        givenViewDidLoad()
        let expectedHeight: CGFloat = -100
        let scrollView = UIScrollView()
        scrollView.contentOffset.y = expectedHeight
        
        sut.scrollViewDidScroll(scrollView)
        
        XCTAssertEqual(sut.stickHeaderViewHeightConstraint.constant, -expectedHeight)
    }
    
    
    func testScrollViewDidChange_WhenContentYOffsetIsGreaterThanMinHeightOfStickyHeaderView_ThenHeightContraintOfStickyHeaderViewIsMinHeight() {
        givenViewDidLoad()
        let scrollView = UIScrollView()
        scrollView.contentOffset.y = 150
        
        sut.scrollViewDidScroll(scrollView)
        
        XCTAssertEqual(sut.stickHeaderViewHeightConstraint.constant, StickyHeaderView.MinHeight)
    }
    
    
    func testConfirmViewModel_WhenCreated() {
        XCTAssertTrue(sut.viewModel is ListViewModel)
        XCTAssertTrue((sut.viewModel as! ListViewModel).unsplashService is UnsplashListService)
    }
    
    
    func testViewDidLoad_ThenCallFetchDatasOfViewModel() {
        let expectedWasCalled = "called fetchDatas()"
        givenHasViewModelSub()
        
        
        sut.viewDidLoad()
        
        
        XCTAssertTrue(viewModelStub.wasCalled.contains(expectedWasCalled))
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
            sut = MainViewController()
            givenHasViewModelSub()
            sut.tableView = tableView
            let consraint = NSLayoutConstraint()
            sut.stickHeaderViewHeightConstraint = consraint
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
}
