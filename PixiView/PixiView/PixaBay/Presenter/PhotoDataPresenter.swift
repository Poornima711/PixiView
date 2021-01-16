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
            _ = photoData?.hits.map {
                self.dataModel.downloadImage(url: $0.previewURL) { (success) in
                    if success {
                        self.controller?.imgArray = self.getPhotoArray()
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func getPhotoArray() -> [UIImage] {
        let imgArray = dataModel.setImageArray()
        return imgArray
    }
}
