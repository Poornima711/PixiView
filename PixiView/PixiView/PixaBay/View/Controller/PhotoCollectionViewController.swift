//
//  PhotoTableController.swift
//  PixiView
//
//  Created by tcs on 16/01/21.
//

import Foundation
import UIKit

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoDataObject?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        cell.setUIForCell()
        if let url = photoDataObject?[indexPath.row].previewURL {
            cell.imageView.loadThumbnail(urlString: url) { success in
                if success {
                    print("Succes")
                }
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

    func updateNextSet() {
        page += 1
        guard let isPaginating = presenter?.isPaginating(), !isPaginating else {
            return
        }
        callSearchApi(pagination: true)
    }
    
}

extension PhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "PixiView", bundle: nil)
        if let detail = storyBoard.instantiateViewController(withIdentifier: "DetailViewController" ) as? DetailViewController {
            detail.responseObject = responseObject
            detail.photoDataObject = photoDataObject
            detail.selectedPosition = indexPath.row
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
