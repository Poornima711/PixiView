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
    private var responseObject: PhotoResponse?
    
    init(controller: ViewController) {
        self.controller = controller
    }
    
    func getSearchResult(searchKey: String, pageNumber: Int, completion: @escaping (_ success: Bool) -> Void) {
        dataModel.callSearch(for: searchKey, page: "\(pageNumber)") { (photoData) in
            if photoData?.hits.count == 0 {
                //self.controller?.showAlertOnNoResults()
                completion(false)
            } else {
                self.responseObject = photoData
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
