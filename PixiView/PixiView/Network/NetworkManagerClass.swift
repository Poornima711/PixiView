//
//  NetworkManager.swift
//  PixiView
//
//  Created by Poornima Rao on 18/01/2021.
//

import Foundation
/**
    This class is a Reachability Wrapper Class. It checks whether device has internet connection or not
*/
class NetworkManagerClass {
    
    var reachability: Reachability!
    static let sharedInstance = NetworkManagerClass()
    
    private init() {
        guard let reachabilty = Reachability() else {
            return
        }
        self.reachability = reachabilty
    }
    
    var isReachability: Bool {
            return reachability.currentReachabilityStatus != .notReachable
    }
    
    func startNotifier() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func stopNotifier() {
        reachability.stopNotifier()
    }
}
