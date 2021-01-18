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
    
    /**
        This is an extremely complicated method that concatenates the first and last name and produces the full name.
     
        - Parameter firstname: The first part of the full name.
        - Parameter lastname: The last part of the fullname.
        - Returns: The full name as a string value.
    */
    func getSearchResultsFromXML(searchKey: String, pageNumber: Int, pagination: Bool, completion: @escaping (_ success: Bool) -> Void) {
        dataModel.callSearchXml(for: searchKey, page: "\(pageNumber)", pagination: pagination) { [weak self] (photoData) in
            if photoData?.hits.count == 0 {
                completion(false)
            } else {
                self?.responseObject = photoData
                self?.photoDataObject.append(contentsOf: photoData?.hits ?? [])
                completion(true)
            }
        }
    }
    
    func fillSearchArray(searchText: String) {
        if var queryArray = DataManager.readDataFromUserDefaults(key: "queryArray") as? [String] {
            if !queryArray.contains(searchText) {
                queryArray.append(searchText)
            }
            PhotoViewController.searchQueryArray = queryArray
        }
        DataManager.writeDataToUserDefaults(data: PhotoViewController.searchQueryArray as AnyObject, key: "queryArray")
        updateQueryArray()
    }
    
    func updateQueryArray() {
        if var queryArray = DataManager.readDataFromUserDefaults(key: "queryArray") as? [String] {
            if  queryArray.count >= 10 {
                for index in 0...queryArray.count - 10 {
                    queryArray.remove(at: index)
                }
                PhotoViewController.searchQueryArray = queryArray
            }
        }
        DataManager.writeDataToUserDefaults(data: PhotoViewController.searchQueryArray as AnyObject, key: "queryArray")
    }
}
