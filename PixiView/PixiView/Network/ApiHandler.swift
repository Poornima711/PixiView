//
//  ApiHandler.swift
//  PixiView
//
//  Created by Poornima Rao on 15/01/21.
//

import Foundation

class ApiHandler: NSObject {
    
    func sendRequestToServer(serviceParameters: URLRequestParameters, completionHandler: @escaping ((_ apiRequestResponse: ApiServiceRequestResponse<Data, ApiError>) -> Void)) {
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        guard let request = serviceParameters.getUrlRequest().request else {
            completionHandler(ApiServiceRequestResponse(requestStatus: .failure(.serverError), response: nil))
            return
        }
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let resultData = data, error == nil else {
                    if let err = error {
                        completionHandler(ApiServiceRequestResponse(requestStatus: .failure(.custom(err as Error, err.localizedDescription)), response: response))
                        return
                    }
                    completionHandler(ApiServiceRequestResponse(requestStatus: .failure(.serverError), response: response))
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("response = \(String(describing: response))")
                }
                
                let responseString = String(data: resultData, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                completionHandler(ApiServiceRequestResponse(requestStatus: .success(resultData), response: response))
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
