//
//  DetailViewController.swift
//  PixiView
//
//  Created by Poornima Rao on 18/01/21.
//

import UIKit
//new
/**
    This is UIViewController Class which implements pagination methods.
    - configures UIPageViewControllerDataSource and UIPageViewControllerDelegate methods

 */
class DetailViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageController: UIPageViewController!
    var controllers = [UIViewController]()
    
    var responseObject: PhotoResponse?
    var photoDataObject: [PhotoData]?
    var selectedPosition: Int = 0
    var isNewSearch = false
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PixiView"
        pageControl.numberOfPages = photoDataObject?.count ?? 0
        setupPageController()
        
        if isNewSearch {
            controllers.removeAll()
        }
        for index in 0..<(photoDataObject?.count ?? 0) {
            controllers.append(self.viewForIndex(index: index))
        }
        
        //set controllers
        pageController.setViewControllers([self.controllers[selectedPosition]], direction: .forward, animated: false, completion: nil)
        pageControl.currentPage = selectedPosition
    }
    
    /**
     This method sets up PageViewController and add it to the controller as child.
     */
    private func setupPageController() {
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .clear
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
    
    /**
        This method provides the UIViewController of specified index.
     
        - Parameter index: Int value of Index specifies the UIViewController to be returned
        - Returns: PageContentViewController Object
    */
    func viewForIndex(index: Int) -> PageContentViewController {
        
        let storyboard =  UIStoryboard(name: "PixiView", bundle: nil)
        let pageContentObj: PageContentViewController = ((storyboard.instantiateViewController(withIdentifier: "PageContentViewController")) as? PageContentViewController)!
        
        pageContentObj.index = index
        pageControl.currentPage = index
        pageContentObj.numberOfPages = self.responseObject?.totalHits ?? 0
        pageContentObj.url = self.photoDataObject?[index].largeImageURL ?? ""
        return pageContentObj
    }
    
    // MARK: - Paging Delegates
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let controller = pageViewController.viewControllers![0]
        pageControl.currentPage = controllers.firstIndex(of: controller)!
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vController = viewController as? PageContentViewController else { return nil }

        let nextIndex = vController.index + 1

        guard controllers.count != nextIndex else {
            return controllers.first
        }

        guard controllers.count > nextIndex else {
            return nil
        }

        return controllers[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vController = viewController as? PageContentViewController else { return nil }

        let previousIndex = vController.index - 1

        guard previousIndex >= 0 else {
            return controllers.last
        }

        guard controllers.count > previousIndex else {
            return nil
        }

        return controllers[previousIndex]
    }
    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//         guard let currentIndex = controllers.firstIndex(of: viewController), currentIndex > 0 else {
//              return nil
//         }
//         selectedPosition = currentIndex - 1
//         let previousIndex = abs((currentIndex - 1) % controllers.count)
//         return controllers[previousIndex]
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//         guard let currentIndex = controllers.firstIndex(of: viewController), (currentIndex + 1 <= (self.photoDataObject?.count ?? 0) - 1) else {
//              return nil
//         }
//         selectedPosition = currentIndex + 1
//         let nextIndex = abs((currentIndex + 1) % controllers.count)
//         return controllers[nextIndex]
//    }
}
