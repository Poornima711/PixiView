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
        dataModel.callSearch(for: searchKey, page: "\(pageNumber)", pagination: pagination) { [weak self] (photoData) in
            if photoData?.hits.count == 0 {
                completion(false)
            } else {
                self?.responseObject = photoData
                self?.photoDataObject.append(contentsOf: photoData?.hits ?? [])
                completion(true)
            }
        }
    }
    
    func getResponseObject() -> PhotoResponse? {
        return self.responseObject
    }
    
    func getPhotoDataObject() -> [PhotoData]? {
        return self.photoDataObject
    }
    
    func clearPhotoDataArray() {
        self.photoDataObject.removeAll()
    }
    
    func isPaginating() -> Bool {
        return dataModel.getPaginatingFlag()
    }
    
    func createThumbnailImages(image: UIImage) {
        self.photoArray?.append(image)
    }
    
    func callXMParser() {
        self.dataModel.tempParserMethod()
    }
}
