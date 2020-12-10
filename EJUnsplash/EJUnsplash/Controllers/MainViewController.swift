//
//  ViewController.swift
//  EJUnsplash
//
//  Created by John on 2020/12/10.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var stickyHeaderView: StickyHeaderView!
    @IBOutlet var stickHeaderViewHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: stickHeaderViewHeightConstraint.constant, left: 0, bottom: 0, right: 0)
    }


}


extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError()
    }
}


extension MainViewController: UITableViewDelegate {
    static let stickyHeaderViewMinHeight = CGFloat(90)
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var heightConstraint = -scrollView.contentOffset.y
        if heightConstraint < 90 {
            heightConstraint = 90
        }
        stickHeaderViewHeightConstraint.constant = heightConstraint
    }
}

