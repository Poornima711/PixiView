//
//  ApiHandler.swift
//  PixiView
//
//  Created by Poornima Rao on 15/01/21.
//

import Foundation
import CommonCrypto

class ApiHandler: NSObject {
    
    static let sharedInstance: ApiHandler = ApiHandler()
    
    let pinnedPublicKeyHash = [
        "KRzKZztq8UMyGOFcTiBppjD0+PysEEM/fk1eQWJwIDo="
    ]
    
    private let rsa2048Asn1Header: [UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    
    private func sha256(_ data: Data) -> String {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        hash.withUnsafeMutableBytes { (hashBuffer) in
            data.withUnsafeBytes { (buffer) in
                _ = CC_SHA256(buffer.baseAddress!, CC_LONG(buffer.count), hashBuffer.bindMemory(to: UInt8.self).baseAddress)
            }
        }
        return Data(bytes: hash, count: hash.count).base64EncodedString()
    }
    
    func sendRequestToServer(serviceParameters: URLRequestParameters, completionHandler: @escaping ((_ apiRequestResponse: ApiServiceRequestResponse<Data, ApiError>) -> Void)) {
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        guard let request = serviceParameters.getUrlRequest().request else {
            completionHandler(ApiServiceRequestResponse(requestStatus: .failure(.serverError), response: nil))
            return
        }
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
        
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
    
    func downloadImageFromURL(url: String, completionHandler: @escaping ((_ apiRequestResponse: ApiServiceRequestResponse<Data, ApiError>) -> Void)) {
        if url.isEmpty { return }
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
        guard let url = URL(string: url) else {
            print("Could not create URL")
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
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

// MARK: - UrlSession delegate
extension ApiHandler: URLSessionDelegate {
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Set SSL policies for domain name check
        let policies = NSMutableArray()
        policies.add(SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString)))
        SecTrustSetPolicies(serverTrust, policies)
        
        // Evaluate server certificate
        let result = SecTrustResultType.invalid
        _ = SecTrustEvaluateWithError(serverTrust, nil)
        //SecTrustEvaluate(serverTrust, &result)
        var isServerTrusted = result == .unspecified || result == .proceed ? true : false
        
        if isServerTrusted {
            let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
            //Compare public key
            let policy = SecPolicyCreateBasicX509()
            let cfCertificates = [certificate] as CFArray
            
            var trust: SecTrust?
            SecTrustCreateWithCertificates(cfCertificates, policy, &trust)
            
            let pubKey = SecTrustCopyKey(trust!)
            //SecTrustCopyPublicKey(trust!)
            var error: Unmanaged<CFError>?
            if let pubKeyData = SecKeyCopyExternalRepresentation(pubKey!, &error) {
                var keyWithHeader = Data(bytes: rsa2048Asn1Header, count: rsa2048Asn1Header.count)
                keyWithHeader.append(pubKeyData as Data)
                let sha256Key = sha256(keyWithHeader)
                print(sha256Key)
                if !(pinnedPublicKeyHash).contains(sha256Key) {
                    isServerTrusted = false
                }
            } else {
                isServerTrusted = false
            }
        }
        
        if isServerTrusted {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
        
    }
}
