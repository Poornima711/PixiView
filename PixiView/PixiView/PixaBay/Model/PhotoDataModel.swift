//
//  PixaBayHandler.swift
//  PixiView
//
//  Created by Poornima Rao on 15/01/21.
//

import Foundation
import UIKit
/**
 This class is the Model class. It contains API Calls
 */
class PhotoDataModel: NSObject {
    
    /**
        The variable fetches API Key from the properlist file.
    */
    private var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Pixabay-Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Pixabay-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'Pixabay-Info.plist'.")
        }
        return value
    }
    
    var isPaginating = false
    
    /**
        This method calls Search API to fetch JSON data.
     
         - Parameter searchKey: The text searched by user
         - Parameter page: The number of page needed. New search is always zero and page number changes on scroll
         - Parameter pagination: The bool value indicating whether pagination is needed
         - Parameter completion: closure takes PhotoResponse object
    */
    func callSearch(for searchKey: String, page: String, pagination: Bool, completion: @escaping (_ responseData: PhotoResponse?, _ error: ApiError?) -> Void) {
        let urlString = URLConstants.searchURL
        let inputParams: [String: AnyObject] = ["key": apiKey as AnyObject, "q": searchKey as AnyObject, "image_type": "photo" as AnyObject, "page": page as AnyObject]
        let request = URLRequestParameters(requestURL: urlString, requestType: .get, requestParams: inputParams)
        if pagination {
            self.isPaginating = true
        }
        ApiHandler.sharedInstance.sendRequestToServer(serviceParameters: request) { (requestResponse) in
            let statusCode = (requestResponse.response as? HTTPURLResponse)?.statusCode ?? 0
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                switch requestResponse.requestStatus {
                case .success(let data):
                    do {
                        let jsonData = try JSONDecoder().decode(PhotoResponse.self, from: data)
                        completion(jsonData, nil)
                        self.isPaginating = false
                        print(jsonData)
                    } catch {
                       print("Could not decode the data")
                        self.isPaginating = false
                    }
                case .failure(let error):
                    print(error)
                    completion(nil, error)
                }
            case ResponseStatusCode.badRequest.rawValue:
                print("Bad Access")
                completion(nil, ApiError.serverError)
            case ResponseStatusCode.serverError.rawValue:
                print("Server Error")
                completion(nil, ApiError.serverError)
            case ResponseStatusCode.tooManyRequests.rawValue:
                completion(nil, ApiError.serverError)
                print("Too many requests received. Try after some time")
            case ResponseStatusCode.unauthorised.rawValue:
                completion(nil, ApiError.serverError)
                print("Unauthorised")
            default:
                print("Error")
            }
        }
    }
    
    /**
        This method used to get the status of API Pagination call.
    */
    func getPaginatingFlag() -> Bool {
        return isPaginating
    }
    
    /**
        This method calls Search API to fetch XML data.
     
         - Parameter searchKey: The text searched by user
         - Parameter page: The number of page needed. New search is always zero and page number changes on scroll
         - Parameter pagination: The bool value indicating whether pagination is needed
         - Parameter completion: closure takes PhotoResponse  data object
    */
    func callSearchXml(for searchKey: String, page: String, pagination: Bool, completion: @escaping (_ responseData: PhotoResponse?, _ error: ApiError?) -> Void) {
        let urlString = URLConstants.searchURL
        let inputParams: [String: AnyObject] = ["key": apiKey as AnyObject, "q": searchKey as AnyObject, "image_type": "photo" as AnyObject, "page": page as AnyObject]
        let request = URLRequestParameters(requestURL: urlString, requestType: .get, requestParams: inputParams)
        if pagination {
            self.isPaginating = true
        }
        ApiHandler.sharedInstance.sendRequestToServer(serviceParameters: request) { (requestResponse) in
            let statusCode = (requestResponse.response as? HTTPURLResponse)?.statusCode ?? 0
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                switch requestResponse.requestStatus {
                case .success(let data):
                    let parser = XmlParser(data: data)
                    parser.parse()
                    self.isPaginating = false
                case .failure(let error):
                    print(error)
                    completion(nil, error)
                }
            case ResponseStatusCode.badRequest.rawValue:
                print("Bad Access")
                completion(nil, ApiError.serverError)
            case ResponseStatusCode.pageNotFound.rawValue:
                completion(nil, ApiError.pageNotFound)
            case ResponseStatusCode.serverError.rawValue:
                print("Server Error")
                completion(nil, ApiError.serverError)
            case ResponseStatusCode.tooManyRequests.rawValue:
                print("Too many requests received. Try after some time")
                completion(nil, ApiError.serverError)
            case ResponseStatusCode.unauthorised.rawValue:
                print("Unauthorised")
                completion(nil, ApiError.serverError)
            default:
                print("Error")
            }
        }
    }
}
