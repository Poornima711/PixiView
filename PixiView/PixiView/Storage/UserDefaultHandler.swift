//
//  UserDefaultHandler.swift
//  PixiView
//
//  Created by tcs on 17/01/21.
//

import Foundation
class UserDefaultHandler: NSObject {
    
    /**
     Read data from Userdefaults
     - Parameter key: The key for which the data has to be read.
     */
    class func readDataFromUserDefault(key: String) -> AnyObject? {
        return UserDefaultHandler().retriveDirectValueFromUserDefaults(key)
    }
    
    /**
     Write data to Userdefaults
     - Parameter key: The key for which the data has to be written.
     - Parameter data: The data to be set.
     */
    class func writeDataToUserDefault(data: AnyObject?, key: String) {
        UserDefaultHandler().addObjectInUserDefaults(key, value: data as? NSCoding)
    }
    
    /**
     Add data to Userdefaults
     - Parameter key: The key for which the data has to be set.
     - Parameter value: The data to be set.
     */
    func addObjectInUserDefaults(_ key: String, value: AnyObject?) {
        
        let defaults = UserDefaults.standard
        
        defaults.set(value, forKey: key)
        defaults.synchronize()
        
    }
    
    /**
     Retrieve data from Userdefaults
     - Parameter key: The key for which the data has to be retrieved.
     */
    func retriveDirectValueFromUserDefaults(_ key: String) -> AnyObject? {
        
        let defaults = UserDefaults.standard
        guard let value =  defaults.object(forKey: key) else { return nil}
        return value as AnyObject
    }
    
}
