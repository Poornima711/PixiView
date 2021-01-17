//
//  PhotoPageViewController.swift
//  PixiView
//
//  Created by tcs on 16/01/21.
//

import Foundation
import UIKit

extension PhotoViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func viewForIndex(index: Int) -> ImageViewController {
        
        let storyboard =  UIStoryboard(name: "PixiView", bundle: nil)
        
        let pageContentObj: ImageViewController = ((storyboard.instantiateViewController(withIdentifier: "ImageViewController")) as? ImageViewController)!
        
        pageContentObj.index = index
        pageContentObj.url = self.photoDataObject?[index].largeImageURL ?? ""
        if let url = self.photoDataObject?[index].largeImageURL {
            self.presenter?.download(url: url, completion: { (image) in
                DispatchQueue.main.async {
                    pageContentObj.startLoader()
                    pageContentObj.image = image
                    pageContentObj.setImage(image: image ?? UIImage())
                    pageContentObj.stopLoader()
                }
            })
        }
        return pageContentObj
    }
    
    // MARK: - paging delegates
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let temp = viewController as? ImageViewController else { return UIViewController() }
        var index = temp.index + 1
        if index == photoDataObject?.count ?? 0 - 1 {
            index = 0
        }
        return index >= (self.photoDataObject?.count ?? 0 - 1) ? nil: self.viewForIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let temp = viewController as? ImageViewController else { return UIViewController() }
        return temp.index == 0 ? nil: self.viewForIndex(index: temp.index - 1)
    }
}
