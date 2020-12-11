//
//  ViewController.swift
//  EJUnsplash
//
//  Created by John on 2020/12/10.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stickyHeaderView: StickyHeaderView!
    @IBOutlet weak var stickHeaderViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: IListViewModel = ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: stickHeaderViewHeightConstraint.constant, left: 0, bottom: 0, right: 0)
        
        viewModel.bindPhotoDatas { [weak self] range in
            if range.startIndex == 0 {
                self?.tableView.reloadData()
            } else {
                self?.tableView.insertRows(at: range.map { IndexPath(row: $0, section: 0) }, with: .none)
            }
        }
        viewModel.fetchDatas()
    }


}


extension MainViewController: UITableViewDataSource {
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


extension MainViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var heightConstraint = -scrollView.contentOffset.y
        if heightConstraint < StickyHeaderView.MinHeight {
            heightConstraint = StickyHeaderView.MinHeight
        }
        stickHeaderViewHeightConstraint.constant = heightConstraint
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.didEndDisplayingAt(indexPath: indexPath)
    }
}


extension MainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.prefetchRowsAt(indexPaths: indexPaths)
    }
    
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        viewModel.cancelPrefetchingForRowsAt(indexPaths: indexPaths)
    }
}

