//
//  UserDefaultHandler.swift
//  PixiView
//
//  Created by tcs on 17/01/21.
//

import Foundation
class UserDefaultHandler: NSObject {
    
    class func readDataFromUserDefault(key: String) -> AnyObject? {
        return UserDefaultHandler().retriveDirectValueFromUserDefaults(key)
    }
    
    class func writeDataToUserDefault(data: AnyObject?, key: String) {
        UserDefaultHandler().addObjectInUserDefaults(key, value: data as? NSCoding)
    }
    
    func addObjectInUserDefaults(_ key: String, value: AnyObject?) {
        
        let defaults = UserDefaults.standard
        
        defaults.set(value, forKey: key)
        defaults.synchronize()
        
    }
    
    func retriveDirectValueFromUserDefaults(_ key: String) -> AnyObject? {
        
        let defaults = UserDefaults.standard
        guard let value =  defaults.object(forKey: key) else { return nil}
        return value as AnyObject
    }
    
}
