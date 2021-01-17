//
//  UIImage+Additions.swift
//  PixiView
//
//  Created by tcs on 16/01/21.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadThumbnail(urlString: String) {
        
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
                    imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    self.image = imageToCache
                    }
                case .failure(let error):
                    print(error)
                    self.image = UIImage(named: "noImage")
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
}
