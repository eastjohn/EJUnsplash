//
//  PageViewController.swift
//  EJUnsplash
//
//  Created by John on 2020/12/13.
//

import UIKit

class PageViewController: UIPageViewController {
    static let storyboardID = "PageViewController"
    
    var viewModel: IPageViewModel!
    var selectedIndex = -1

    static func createFromStoryboard(unsplashService: UnsplashService) -> PageViewController? {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardID) as? PageViewController
        viewController?.setUnsplashService(unsplashService)
        return viewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        guard let detailViewController = DetailViewController.createFromStoryboard(url: viewModel.urlAt(selectedIndex), index: selectedIndex) else { return }
        setViewControllers([detailViewController], direction: .forward, animated: false, completion: nil)
    }
    
    
    func setUnsplashService(_ service: UnsplashService) {
        viewModel = PageViewModel(service: service)
    }
    
    
    func setPhotoDatas(_ photoDatas: [PhotoInfo]) {
        viewModel.setPhotoDatas(photoDatas)
    }

}


//extension PageViewController: UIPageViewControllerDelegate {
//    
//}


extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getDetailViewController(viewController: viewController, increaseIndex: -1)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getDetailViewController(viewController: viewController, increaseIndex: 1)
    }
    
    
    private func getDetailViewController(viewController: UIViewController, increaseIndex: Int) -> DetailViewController? {
        guard let detailViewController = viewController as? DetailViewController else { return nil }
        let nextIndex = detailViewController.index + increaseIndex
        guard let url = viewModel.urlAt(nextIndex) else { return nil }
        return DetailViewController.createFromStoryboard(url: url, index: nextIndex)
    }
    
    
}
