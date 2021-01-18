//
//  PhotoDataPresenter.swift
//  PixiView
//
//  Created by Poornima Rao on 16/01/21.
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
    
    /**
        This method parses JSON data.
     
         - Parameter searchKey: The text searched by user
         - Parameter pageNumber: The number of page needed. New search is always zero and page number changes on scroll
         - Parameter pagination: The bool value indicating whether pagination is needed
         - Parameter completion: closure to indicate whether the completed executing successfully
         - Returns: The full name as a string value.
    */
    func getSearchResult(searchKey: String, pageNumber: Int, pagination: Bool, completion: @escaping (_ success: Bool) -> Void) {
        if NetworkManagerClass.sharedInstance.isReachability {
            dataModel.callSearch(for: searchKey, page: "\(pageNumber)", pagination: pagination) { [weak self] (photoData, error) in
                
                if photoData == nil, error != nil {
                    switch error {
                    case .serverError:
                        self?.controller?.showAlert(title: ErrorMessages.serverUnreachable.rawValue, message: "")
                    default:
                        self?.controller?.showAlert(title: ErrorMessages.networkUnreachable.rawValue, message: "")
                    }
                }
                
                if photoData?.hits.count == 0 {
                    completion(false)
                } else {
                    self?.responseObject = photoData
                    self?.photoDataObject.append(contentsOf: photoData?.hits ?? [])
                    completion(true)
                }
            }
        } else {
            controller?.showAlert(title: ErrorMessages.networkUnreachable.rawValue, message: "")
        }
    }
    
    /**
        This method parses XML data.
     
         - Parameter searchKey: The text searched by user
         - Parameter pageNumber: The number of page needed. New search is always zero and page number changes on scroll
         - Parameter pagination: The bool value indicating whether pagination is needed
         - Parameter completion: closure to indicate whether the completed executing successfully
         - Returns: The full name as a string value.
    */

    func getSearchResultsFromXML(searchKey: String, pageNumber: Int, pagination: Bool, completion: @escaping (_ success: Bool) -> Void) {
        if NetworkManagerClass.sharedInstance.isReachability {
            dataModel.callSearchXml(for: searchKey, page: "\(pageNumber)", pagination: pagination) { [weak self] (photoData, error) in
                
                if photoData == nil, error != nil {
                    switch error {
                    case .serverError:
                        self?.controller?.showAlert(title: ErrorMessages.serverUnreachable.rawValue, message: "")
                    default:
                        self?.controller?.showAlert(title: ErrorMessages.networkUnreachable.rawValue, message: "")
                    }
                }
                
                if photoData?.hits.count == 0 {
                    completion(false)
                } else {
                    self?.responseObject = photoData
                    self?.photoDataObject.append(contentsOf: photoData?.hits ?? [])
                    completion(true)
                }
            }
        } else {
            completion(false)
             controller?.showAlert(title: ErrorMessages.networkUnreachable.rawValue, message: "")
        }
    }
    
    /**
        This method used to fetch PhotoResponse Object.
     
         - Returns: The PhotoResponse Object.
    */
    func getResponseObject() -> PhotoResponse? {
        return self.responseObject
    }
    
    /**
        This method used to fetch PhotoData Array.
     
         - Returns: The PhotoData Array.
    */
    func getPhotoDataObject() -> [PhotoData]? {
        return self.photoDataObject
    }
    
    /**
        This method is used to PhotoData Array.
    */
    func clearPhotoDataArray() {
        self.photoDataObject.removeAll()
    }
    
    /**
        This method used to get the status of API Pagination call.
    */
    func isPaginating() -> Bool {
        return dataModel.getPaginatingFlag()
    }
    
    /**
        This method fills the suggestion array and also stores the array in UserDefaults.
     
         - Parameter searchText: The text searched by user
    */
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
    
    /**
        This method removes the query from the list if it exceeds the count  of 10 and updates the array in UserDefaults.
    */
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
