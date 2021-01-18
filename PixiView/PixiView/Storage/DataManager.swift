//
//  DataManager.swift
//  PixiView
//
//  Created by tcs on 17/01/21.
//

import Foundation

class DataManager: NSObject {
    
    /**
     Read data from Userdefaults
     - Parameter key: The key for which the data has to be retrieved.
     */
    class func readDataFromUserDefaults(key: String) -> AnyObject? {
        return UserDefaultHandler.readDataFromUserDefault(key: key)
    }
    
    /**
     Write data to Userdefaults
     - Parameter key: The key for which the data has to be written.
     - Parameter data: The data to be set.
     */
    class func writeDataToUserDefaults(data: AnyObject, key: String) {
        UserDefaultHandler.writeDataToUserDefault(data: data, key: key)
    }
    
    /**
     Remove data from Userdefaults
     - Parameter key: The key for which the data has to be removed.
     */
    class func removeUserdefaultValue(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
