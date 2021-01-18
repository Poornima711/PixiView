//
//  DetailViewController.swift
//  PixiView
//
//  Created by tcs on 18/01/21.
//

import UIKit
//new
class DetailViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageController: UIPageViewController!
    var controllers = [UIViewController]()
    
    var responseObject: PhotoResponse?
    var photoDataObject: [PhotoData]?
    var selectedPosition: Int = 0
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PixiView"
        pageControl.numberOfPages = photoDataObject?.count ?? 0
        setupPageController()
        
        let startingViewController: PageContentViewController! = self.viewForIndex(index: selectedPosition)
        if let url = photoDataObject?[selectedPosition].largeImageURL {
            startingViewController.url = url
        }
        startingViewController.numberOfPages = responseObject?.totalHits ?? 0
        let viewControllers: [UIViewController] = [startingViewController]
        
        pageController.setViewControllers(viewControllers, direction: .forward, animated: false)
    }
    
    private func setupPageController() {
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .clear
        self.pageController?.view.frame = CGRect(x: 0, y: self.pageView.frame.origin.y, width: self.pageView.frame.width, height: self.pageView.frame.size.height)
        self.addChild(self.pageController!)
        self.pageView.addSubview(self.pageController!.view)
        
        // constraints
        self.pageController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.pageController!.view.topAnchor.constraint(equalTo: self.pageView.topAnchor, constant: 0).isActive = true
        self.pageController!.view.bottomAnchor.constraint(equalTo: self.pageView.bottomAnchor, constant: 0).isActive = true
        self.pageController!.view.leadingAnchor.constraint(equalTo: self.pageView.leadingAnchor, constant: 0).isActive = true
        self.pageController!.view.trailingAnchor.constraint(equalTo: self.pageView.trailingAnchor, constant: 0).isActive = true
        
        self.pageController?.didMove(toParent: self)
    }
    
    func viewForIndex(index: Int) -> PageContentViewController {
        
        let storyboard =  UIStoryboard(name: "PixiView", bundle: nil)
        
        let pageContentObj: PageContentViewController = ((storyboard.instantiateViewController(withIdentifier: "PageContentViewController")) as? PageContentViewController)!
        
        pageContentObj.index = index
        pageControl.currentPage = index
        pageContentObj.numberOfPages = self.responseObject?.totalHits ?? 0
        pageContentObj.url = self.photoDataObject?[index].largeImageURL ?? ""
        return pageContentObj
    }
    
    // MARK: - paging delegates
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let temp = viewController as? PageContentViewController else { return UIViewController() }
        var index = temp.index + 1
        if index == photoDataObject?.count ?? 0 - 1 {
            index = 0
        }
        return index >= (self.photoDataObject?.count ?? 0 - 1) ? nil: self.viewForIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let temp = viewController as? PageContentViewController else { return UIViewController() }
        return temp.index == 0 ? nil: self.viewForIndex(index: temp.index - 1)
    }

}
