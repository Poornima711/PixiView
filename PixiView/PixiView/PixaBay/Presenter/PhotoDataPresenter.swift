//
//  PhotoDataPresenter.swift
//  PixiView
//
//  Created by tcs on 16/01/21.
//

import Foundation
import UIKit

class PhotoDataPresenter {
    
    private let dataModel = PhotoDataModel()
    private var controller: ViewController?
    
    init(controller: ViewController) {
        self.controller = controller
    }
    
    func getSearchResult(searchKey: String, completion: @escaping (_ success: Bool) -> Void) {
        dataModel.callSearch(for: searchKey) { (photoData) in
            if photoData?.hits.count == 0 {
                self.controller?.showAlertOnNoResults()
            } else {
                _ = photoData?.hits.map {
                    self.dataModel.downloadImage(url: $0.previewURL) { (success) in
                        if success {
                            self.controller?.imgArray = self.getPhotoArray()
                            self.downloadLargeImages(response: photoData)
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                }
            }
        }
    }
    
    func downloadLargeImages(response: PhotoResponse?) {
        _ = response?.hits.map {
            self.dataModel.downloadImage(url: $0.largeImageURL) { (success) in
                if success {
                    self.controller?.largeImgArray = self.getLargeImagesArray()
                }
            }
        }
    }
    
    func getPhotoArray() -> [UIImage] {
        var imgArray = [UIImage]()
        imgArray = dataModel.setImageArray()
        return imgArray
    }
    
    func getLargeImagesArray() -> [UIImage] {
        var imgArray = [UIImage]()
        imgArray = dataModel.setLargeImageArray()
        return imgArray
    }
}
