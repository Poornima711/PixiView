//
//  URLParameters.swift
//  PixiView
//
//  Created by Poornima Rao on 15/01/21.
//

import Foundation

/**
 The enum containing Error Codes
 */
enum ResponseStatusCode: Int {
    case success = 200
    case badRequest = 400
    case unauthorised = 401
    case tooManyRequests = 429
    case serverError = 500
}

/**
 The enum containing Request Types
 */
enum RequestType: String {
    case get = "GET"
    case post = "POST"
}

/**
 The enum containing Error Messages
 */
enum ErrorMessages: String {
    case networkUnreachable = "No Network Connectivity"
    case serverUnreachable = "Could not connect to server. Please try again later"
    case noDataAvailable = "No data available"
    case generalError = "Error"
    case notJSON = "not a json"
}

/**
 The enum containing Error
 */
enum ApiError: Error {
    case noInternetConnection
    case serverError
    case noDataAvailable
    case custom(_ error: Error, _ message: String)
}

/**
 The enum containing Request Scenarios
 */
enum ApiServiceRequestStatus<T1, T2> where T2: Error {
    case success(_ data: T1)
    case failure(_ error: T2)
}

/**
 The enum containing ApiServiceRequestResponse Scenarios
 */
struct ApiServiceRequestResponse<T1, T2> where T2: Error {
    var requestStatus: ApiServiceRequestStatus<T1, T2>
    var response: URLResponse?
}

/**
 This struct provides URL Request
 */
struct URLRequestParameters {
    private(set) var requestURL: String
    private(set) var requestType: RequestType
    private(set) var requestParams: [String: AnyObject]?
    private(set) var requestCachingPolicy: NSURLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    private(set) var requestTimeOut: TimeInterval = 25
    private(set) var additionalHeaders: [String: String] = Dictionary() //key:value
    private(set) var tag: AnyObject?
    
    /**
     This method creates URLRequest
     - Returns: URLRequest and error if any
     */
    func getUrlRequest() -> (request: URLRequest?, errorMessage: String) {
        
        switch requestType {
        case .post:
            guard let url = URL(string: requestURL) else {
                return (nil, "URL string passed is not valid")
            }
            let request = handlePostRequest(url: url)
            return (request, "")
        case .get:
            guard var components = URLComponents(string: requestURL) else {
                return (nil, "URL string passed is not valid")
            }
            if let param = requestParams as? [String: String] {
                if !(param.count == 1 && param.keys.first == "" && components.queryItems?.count == 1) {
                    components.queryItems = param.map { (key, value) in
                        URLQueryItem(name: key, value: value)
                    }
                }
                
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            guard let url = components.url else {
                return (nil, "URL string passed is not valid")
            }
            let request = handleGetRequest(url: url)
            return (request, "")
        }
    }
    
    /**
     This method creates URLRequest
     - Parameter url: URL for the post request
     - Returns: URLRequest
     */
    func handlePostRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.cachePolicy = requestCachingPolicy
        request.timeoutInterval = requestTimeOut
        // pass dictionary to nsdata object and set it as request body
        if let requestParams = requestParams {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: requestParams, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        for header in additionalHeaders {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
    
    /**
     This method creates URLRequest
     - Parameter url: URL for the get request
     - Returns: URLRequest
     */
    func handleGetRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.cachePolicy = requestCachingPolicy
        request.timeoutInterval = requestTimeOut
        for header in additionalHeaders {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        return request
    }
}
