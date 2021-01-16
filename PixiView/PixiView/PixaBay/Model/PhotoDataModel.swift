//
//  PixaBayHandler.swift
//  PixiView
//
//  Created by tcs on 15/01/21.
//

import Foundation
import UIKit

class PhotoDataModel: NSObject {
    
    private let apiKey = "19900784-4f8a196cde58034f3d5553367"
    private var photoArray: [UIImage] = []
    
    func callSearch(for searchKey: String, completion: @escaping (_ responseData: PhotoResponse?) -> Void) {
        let urlString = URLConstants.searchURL
        let inputParams: [String: AnyObject] = ["key": apiKey as AnyObject, "q": searchKey as AnyObject]
        let request = URLRequestParameters(requestURL: urlString, requestType: .get, requestParams: inputParams)
        
        ApiHandler.sharedInstance.sendRequestToServer(serviceParameters: request) { (requestResponse) in
            let statusCode = (requestResponse.response as? HTTPURLResponse)?.statusCode ?? 0
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                switch requestResponse.requestStatus {
                case .success(let data):
                    do {
                        let jsonData = try JSONDecoder().decode(PhotoResponse.self, from: data)
                        completion(jsonData)
                        print(jsonData)
                    } catch {
                       print("Could not decode the data")
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
    
    func downloadImage(url: String, completion: @escaping (_ success: Bool) -> Void) {
        ApiHandler.sharedInstance.downloadImageFromURL(url: url) { (requestResponse) in
            let statusCode = (requestResponse.response as? HTTPURLResponse)?.statusCode ?? 0
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                switch requestResponse.requestStatus {
                case .success(let data):
                    let image = UIImage(data: data) ?? UIImage()
                    self.photoArray.append(image)
                    completion(true)
                case .failure(let error):
                    print(error)
                    completion(false)
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
    
    func setImageArray() -> [UIImage] {
        if photoArray.isEmpty { return [UIImage]() }
        return photoArray
    }
}
