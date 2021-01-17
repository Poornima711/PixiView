//
//  PixaBayHandler.swift
//  PixiView
//
//  Created by tcs on 15/01/21.
//

import Foundation
import UIKit

class PhotoDataModel: NSObject {
    
    //private let apiKey = "19900784-4f8a196cde58034f3d5553367"
    
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
    
    func callSearch(for searchKey: String, page: String, pagination: Bool, completion: @escaping (_ responseData: PhotoResponse?) -> Void) {
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
                        completion(jsonData)
                        self.isPaginating = false
                        print(jsonData)
                    } catch {
                       print("Could not decode the data")
                        self.isPaginating = false
                    }
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
            case ResponseStatusCode.badRequest.rawValue:
                print("Bad Access")
            case ResponseStatusCode.serverError.rawValue:
                print("Server Error")
            case ResponseStatusCode.tooManyRequests.rawValue:
                print("Too many requests received. Try after some time")
            case ResponseStatusCode.unauthorised.rawValue:
                print("Unauthorised")
            default:
                print("Error")
            }
        }
    }
    
    func downloadImage(url: String, completion: @escaping (_ response: Data?) -> Void) {
        ApiHandler.sharedInstance.downloadImageFromURL(url: url) { (requestResponse) in
            let statusCode = (requestResponse.response as? HTTPURLResponse)?.statusCode ?? 0
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                switch requestResponse.requestStatus {
                case .success(let data):
                    completion(data)
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
            case ResponseStatusCode.badRequest.rawValue:
                print("Bad Access")
            case ResponseStatusCode.serverError.rawValue:
                print("Server Error")
            case ResponseStatusCode.tooManyRequests.rawValue:
                print("Too many requests received. Try after some time")
            case ResponseStatusCode.unauthorised.rawValue:
                print("Unauthorised")
            default:
                print("Error")
            }
        }
    }
    
    func getPaginatingFlag() -> Bool {
        return isPaginating
    }
}
