//
//  UIImage+Additions.swift
//  PixiView
//
//  Created by tcs on 16/01/21.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
/**
    This class is custom UIImageView class which enables asynchronous image downloads and image caching.
 */
class CustomImageView: UIImageView {
    
    var imageUrlString: String?

    /**
        This method downloads image asynchronously.
        - Caches the image and sets the image cache if available
        - Parameter urlString: The urlString of the image to be downloaded
        - Parameter completion: Bool value to indicate whether the execution has completed successfully
     */
    func loadThumbnail(urlString: String, completion: @escaping (_ success: Bool) -> Void) {
        
        imageUrlString = urlString
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }
        ApiHandler.sharedInstance.downloadImageFromURL(url: urlString) { (response) in
            let statusCode = (response.response as? HTTPURLResponse)?.statusCode ?? 0
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                switch response.requestStatus {
                case .success(let data):
                    DispatchQueue.main.async {
                        guard let imageToCache = UIImage(data: data) else { return }
                        self.storeInCache(imageToCache: imageToCache, urlString: urlString)
                    }
                    completion(true)
                case .failure(let error):
                    print(error)
                    self.image = UIImage(named: "noImage")
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
    
    /**
     This method stores image in Cache.
     - Parameter imageToCache: Image that needs to be cached
     - Parameter urlString: The urlString of the image to be downloaded
     */
    func storeInCache(imageToCache: UIImage, urlString: String) {
        if self.imageUrlString == urlString {
            self.image = imageToCache
        }
        imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
    }
}
