//
//  MockTableView.swift
//  EJUnsplashTests
//
//  Created by 김요한 on 2020/12/11.
//

import UIKit
@testable import EJUnsplash

class MockTableView: UITableView {
    var wasCalled = ""
    var paramIndexPath: IndexPath!
    var paramIndexPaths = [IndexPath]()
    var paramIdentifier: String =  ""
    lazy var returnCell = UICreator.createListCell()
    
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        paramIdentifier = identifier
        paramIndexPath = indexPath
        return returnCell
    }
    
    
    override func reloadData() {
        wasCalled += "called \(#function)"
    }
    
    
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        wasCalled += "called \(#function)"
        paramIndexPaths = indexPaths
    }
}
