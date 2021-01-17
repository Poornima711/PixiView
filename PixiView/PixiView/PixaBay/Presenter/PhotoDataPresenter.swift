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
    private var controller: PhotoViewController?
    private var responseObject: PhotoResponse?
    private var photoDataObject: [PhotoData] = []
    private var photoArray: [UIImage]?
    
    init(controller: PhotoViewController) {
        self.controller = controller
    }
    
    func getSearchResult(searchKey: String, pageNumber: Int, pagination: Bool, completion: @escaping (_ success: Bool) -> Void) {
        dataModel.callSearch(for: searchKey, page: "\(pageNumber)", pagination: pagination) { (photoData) in
            if photoData?.hits.count == 0 {
                //self.controller?.showAlertOnNoResults()
                completion(false)
            } else {
                self.responseObject = photoData
                self.photoDataObject.append(contentsOf: photoData?.hits ?? [])
                //self.photoDataObject?.append(contentsOf: photoData?.hits ?? [])
                completion(true)
            }
        }
    }
    
    func download(url: String, completion: @escaping (_ image: UIImage?) -> Void) {
        dataModel.downloadImage(url: url) { (data) in
            if data != nil {
                let image = UIImage(data: data ?? Data())
                completion(image)
            }
        }
    }
    
    func getResponseObject() -> PhotoResponse? {
        return self.responseObject
    }
    
    func getPhotoDataObject() -> [PhotoData]? {
        return self.photoDataObject
    }
    
//    func getPhotoArray() -> [UIImage] {
//        var imgArray = [UIImage]()
//        imgArray = dataModel.setImageArray()
//        return imgArray
//    }
//
//    func getLargeImagesArray() -> [UIImage] {
//        var imgArray = [UIImage]()
//        imgArray = dataModel.setLargeImageArray()
//        return imgArray
//    }
    func clearPhotoDataArray() {
        self.photoDataObject.removeAll()
    }
    
    func isPaginating() -> Bool {
        return dataModel.getPaginatingFlag()
    }
    
    func createThumbnailImages(image: UIImage) {
        self.photoArray?.append(image)
    }
}
