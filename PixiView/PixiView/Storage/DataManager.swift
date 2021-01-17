//
//  DataManager.swift
//  PixiView
//
//  Created by tcs on 17/01/21.
//

import Foundation

class DataManager: NSObject {
    
    class func readDataFromUserDefaults(key: String) -> AnyObject? {
        return UserDefaultHandler.readDataFromUserDefault(key: key)
    }
    
    class func writeDataToUserDefaults(data: AnyObject, key: String) {
        UserDefaultHandler.writeDataToUserDefault(data: data, key: key)
    }
    
    class func removeUserdefaultValue(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
