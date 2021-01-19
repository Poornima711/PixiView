//
//  PhotoTableController.swift
//  PixiView
//
//  Created by Poornima Rao on 16/01/21.
//

import Foundation
import UIKit

/**
    This class is a view controller class.
    - Configures SearchBar and Implements UISearchBarDelegate methods
    - Configures UICollectionView and Implements UICollectionView datasource and delegate methods
    - Configures UITableView and Implements UITableView datasource and delegate methods
*/

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoDataObject?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        cell.setUIForCell()
        if let url = photoDataObject?[indexPath.row].previewURL {
            //download Image
            if NetworkManagerClass.sharedInstance.isReachability {
                cell.imageView.loadThumbnail(urlString: url, activityIndicator: self.activityIndicator) { (success) in
                    if success {
                        print("Succes")
                    }
                }
            } else {
                self.showAlert(title: ErrorMessages.networkUnreachable.rawValue, message: "")
            }
        }
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let position = scrollView.contentOffset.y
        if position > (suggestionTableView.contentSize.height - scrollView.frame.size.height) {
            updateNextSet()
        }
    }

    /**
        Calls the Search API on pagination.
        - Call this function when pagination needed.
    */
    func updateNextSet() {
        //increment page count
        page += 1
        isNewSearch = false
        guard let isPaginating = presenter?.isPaginating(), !isPaginating else {
            return
        }

        //call Search API
        callSearchApi(pagination: true)
    }
    
}

extension PhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Redirect to DetailViewController to view full image.
        let storyBoard = UIStoryboard(name: "PixiView", bundle: nil)
        if let detail = storyBoard.instantiateViewController(withIdentifier: "DetailViewController" ) as? DetailViewController {
            detail.responseObject = responseObject
            detail.photoDataObject = photoDataObject
            detail.selectedPosition = indexPath.row
            detail.isNewSearch = isNewSearch
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }
    
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    
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
