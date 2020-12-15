//
//  ViewController.swift
//  EJUnsplash
//
//  Created by John on 2020/12/10.
//

import UIKit

class MainViewController: ListViewController {

    @IBOutlet weak var stickyHeaderView: StickyHeaderView!
    @IBOutlet weak var stickHeaderViewHeightConstraint: NSLayoutConstraint!
    
    var mainViewModel: IListViewModel = ListViewModel(service: UnsplashListService())
    override var viewModel: IListViewModel! {
        return mainViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIs()
        configureViewModel()
    }
    
    override func configureUIs() {
        super.configureUIs()
        tableView.contentInset = UIEdgeInsets(top: stickHeaderViewHeightConstraint.constant, left: 0, bottom: 0, right: 0)
    }
    
    override func configureViewModel() {
        super.configureViewModel()
        viewModel.fetchDatas()
    }

}



// MARK: - UITableViewDelegate
extension MainViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateStickyHeaderViewHeightConstraintByScrollViewYOffset(contentYOffset: scrollView.contentOffset.y)
    }
    
    
    private func updateStickyHeaderViewHeightConstraintByScrollViewYOffset(contentYOffset: CGFloat) {
        var heightConstraint = -contentYOffset
        if heightConstraint < StickyHeaderView.MinHeight {
            heightConstraint = StickyHeaderView.MinHeight
        }
        stickHeaderViewHeightConstraint.constant = heightConstraint
    }
}


extension MainViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard let viewController = SearchViewController.createFromStoryboard() else { return false }
        present(viewController, animated: true, completion: nil)
        return false
    }
}
