//
//  PhotoTableController.swift
//  PixiView
//
//  Created by tcs on 16/01/21.
//

import Foundation
import UIKit

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responseObject?.hits.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        if let url = responseObject?.hits[indexPath.row].previewURL {
            cell.imageView.loadThumbnail(urlString: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            updateNextSet()
        }
    }

    func updateNextSet() {
        page += 1
        callSearchApi()
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        self.pageViewController = storyBoard.instantiateViewController(withIdentifier: "ImagePageViewController" ) as? ImagePageViewController
        
        self.pageViewController?.dataSource = self
        self.pageViewController?.delegate = self
        self.pageViewController?.view.frame = self.view.frame
        
        guard let controller = pageViewController else { return }
        
        let startingViewController: ImageViewController! = self.viewForIndex(index: indexPath.row)
        startingViewController.view.frame = CGRect(x: 0, y: 0, width: controller.view.frame.width, height: controller.view.frame.height)
        
        let viewControllers: NSArray = [startingViewController as Any]
        self.pageViewController?.setViewControllers(viewControllers as? [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        
        if self.title != nil {
            self.pageViewController?.navigationItem.title = self.title
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
     
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: photoCollectionView.frame.size.width/2.5, height: photoCollectionView.frame.size.width/2.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 25, bottom: 0, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
