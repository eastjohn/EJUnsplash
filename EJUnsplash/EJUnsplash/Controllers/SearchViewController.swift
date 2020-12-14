//
//  SearchViewController.swift
//  EJUnsplash
//
//  Created by 김요한 on 2020/12/14.
//

import UIKit

class SearchViewController: UIViewController {
    static let storyboardID = "SearchViewController"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.backgroundImage = UIImage()
        }
    }
    
    
    var viewModel: ISearchViewModel = ListViewModel(service: UnsplashSearchService())

    static func createFromStoryboard() -> SearchViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardID) as? SearchViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUIs()
        configureViewModel()
    }
    
    
    private func configureUIs() {
        self.tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: headerView.frame.height, left: 0, bottom: 0, right: 0)
        searchBar.becomeFirstResponder()
    }
    
    
    private func configureViewModel() {
        viewModel.bindPhotoDatas { [weak self] range in
            self?.updateTableView(range: range)
        }
    }
    
    
    private func updateTableView(range: Range<Int>) {
        if range.startIndex == 0 {
            tableView.reloadData()
        } else {
            tableView.insertRows(at: range.map { IndexPath(row: $0, section: 0) }, with: .none)
        }
    }
    
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let detailViewController = (presentedViewController as? PageViewController)?.viewControllers?.first as? DetailViewController {
            let indexPath = IndexPath(row: detailViewController.index, section: 0)
            tableView.scrollToRow(at: IndexPath(row: detailViewController.index, section: 0), at: .middle, animated: false)
            if let cell = tableView.cellForRow(at: indexPath) {
                tableView.contentOffset.y = -(tableView.frame.height - cell.frame.height) / 2 + cell.frame.minY
            }
        }
        super.dismiss(animated: flag, completion: completion)
    }
}


extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.Identifier, for: indexPath) as? ListViewCell else { fatalError() }
        
        viewModel.updatePhotoInfo(for: indexPath) { photoInfo in
            cell.name = photoInfo.name
        } completionLoadedPhotoImageHandler: { photoImage in
            cell.photoImage = photoImage
        }

        return cell
    }
}


extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = viewModel.photoImageSizeForRowAt(indexPath: indexPath)
        return imageSize.height / imageSize.width * tableView.frame.width
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.didEndDisplayingAt(indexPath: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel as? ListViewModel,
              let pageViewController = PageViewController.createFromStoryboard(unsplashService: viewModel.unsplashService) else { return }
        pageViewController.setPhotoDatas(viewModel.photoDatas)
        pageViewController.selectedIndex = indexPath.row
        pageViewController.modalPresentationStyle = .fullScreen
        pageViewController.transitioningDelegate = self
        present(pageViewController, animated: true, completion: nil)
    }
}



extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.prefetchRowsAt(indexPaths: indexPaths)
    }
    
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        viewModel.cancelPrefetchingForRowsAt(indexPaths: indexPaths)
    }
}


extension SearchViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let indexPath = tableView.indexPathForSelectedRow,
              let cell = tableView.cellForRow(at: indexPath),
              let frame = cell.superview?.convert(cell.frame, to: nil) else { return nil }
        let animator = ListPresentingAnimator()
        animator.originalFrame = frame
        return animator
    }
}


extension SearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text else { return }
        viewModel.fetchDatas(query: query)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
