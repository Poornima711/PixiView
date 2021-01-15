//
//  PixaBayHandler.swift
//  PixiView
//
//  Created by tcs on 15/01/21.
//

import Foundation

class PixaBayHandler: NSObject {
    
    let apiKey = "19900784-4f8a196cde58034f3d5553367"
    
    func callSearch(for searchKey: String) {
        let urlString = URLConstants.searchURL
        let inputParams: [String: AnyObject] = ["key": apiKey as AnyObject, "q": searchKey as AnyObject]
        let request = URLRequestParameters(requestURL: urlString, requestType: .get, requestParams: inputParams)
        
        ApiHandler.sharedInstance.sendRequestToServer(serviceParameters: request) { (requestResponse) in
            let statusCode = (requestResponse.response as? HTTPURLResponse)?.statusCode ?? 0
            switch statusCode {
            case ResponseStatusCode.success.rawValue:
                switch requestResponse.requestStatus {
                case .success(let data):
                    print(data)
                case .failure(let error):
                print(error)
                default:
                    print("default")
                }
            default:
                print("default")
            }
        }
    }
    
}
