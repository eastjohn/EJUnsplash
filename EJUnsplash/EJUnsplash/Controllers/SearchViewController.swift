//
//  SearchViewController.swift
//  EJUnsplash
//
//  Created by 김요한 on 2020/12/14.
//

import UIKit

class SearchViewController: ListViewController {
    static let storyboardID = "SearchViewController"
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.backgroundImage = UIImage()
        }
    }
    @IBOutlet weak var noResultsView: UILabel!
    
    
    var searchViewModel: ISearchViewModel = ListViewModel(service: UnsplashSearchService())
    override var viewModel: IListViewModel! {
        return searchViewModel
    }

    static func createFromStoryboard() -> SearchViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardID) as? SearchViewController
    }
    
    
    override func configureUIs() {
        super.configureUIs()
        tableView.contentInset = UIEdgeInsets(top: headerView.frame.height, left: 0, bottom: 0, right: 0)
        searchBar.becomeFirstResponder()
    }
    
    
    override func updateTableView(range: Range<Int>) {
        updateHiddenOfNoResultsView(range: range)
        super.updateTableView(range: range)
    }
    
    private func updateHiddenOfNoResultsView(range: Range<Int>) {
        noResultsView.isHidden = !isEmpty(range: range)
    }
    
    private func isEmpty(range: Range<Int>) -> Bool {
        return range == 0..<0
    }
}


extension SearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text else { return }
        searchViewModel.fetchDatas(query: query)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
