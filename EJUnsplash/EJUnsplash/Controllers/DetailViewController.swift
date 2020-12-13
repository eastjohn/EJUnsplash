//
//  DetailViewController.swift
//  EJUnsplash
//
//  Created by John on 2020/12/13.
//

import UIKit

class DetailViewController: UIViewController {
    static let storyboardID = "DetailViewController"
//    var url: URL?
    var index = -1
    var viewModel: IDetailViewModel!
    
    static func createFromStoryboard(url: URL?, index: Int) -> DetailViewController? {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardID) as? DetailViewController
        viewController?.setURL(url)
        viewController?.index = index
        return viewController
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func setURL(_ url: URL?) {
        viewModel = DetailViewModel(url: url)
    }

}
