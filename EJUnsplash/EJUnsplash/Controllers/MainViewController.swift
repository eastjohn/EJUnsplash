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
    
    var viewModel: IListViewModel = ListViewModel(service: UnsplashListService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIs()
        configureViewModel()
    }
    
    private func configureUIs() {
        tableView.contentInset = UIEdgeInsets(top: stickHeaderViewHeightConstraint.constant, left: 0, bottom: 0, right: 0)
//        tableView.estimatedRowHeight = 600
    }
    
    private func configureViewModel() {
        viewModel.bindPhotoDatas { [weak self] range in
            self?.updateTableView(range: range)
        }
        viewModel.fetchDatas()
    }

    private func updateTableView(range: Range<Int>) {
        if range.startIndex == 0 {
            tableView.reloadData()
        } else {
            tableView.insertRows(at: range.map { IndexPath(row: $0, section: 0) }, with: .none)
        }
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = viewModel.photoImageSizeForRowAt(indexPath: indexPath)
        return imageSize.height / imageSize.width * tableView.frame.width
    }
    
    
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
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.didEndDisplayingAt(indexPath: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: 아래코드는 테스트 코드로 다시 작성해야한다.
        let pageViewController = PageViewController.createFromStoryboard(unsplashService: (viewModel as? ListViewModel)!.unsplashService)
        pageViewController?.setPhotoDatas((viewModel as? ListViewModel)!.photoDatas)
        pageViewController?.selectedIndex = indexPath.row
        pageViewController?.modalPresentationStyle = .fullScreen
        present(pageViewController!, animated: true, completion: nil)
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

