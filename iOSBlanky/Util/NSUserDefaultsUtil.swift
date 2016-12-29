//
//  NSUserDefaultsUtil.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/10/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation

class NSUserDefaultsUtil {
    
    class func saveInt(_ key: String, value: Int) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    class func getInt(_ key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    class func saveString(_ key: String, value: String) {
        UserDefaults.standard.setValue(value, forKeyPath: key)
    }
    
    class func getString(_ key: String) -> String? {
        return UserDefaults.standard.object(forKey: key) as? String
    }
    
    class func saveBool(_ key: String, value: Bool) {
        UserDefaults.standard.setValue(value, forKeyPath: key)
    }
    
    class func getBool(_ key: String) -> Bool? {
        return UserDefaults.standard.object(forKey: key) as? Bool
    }
    
    class func deleteAllUserDefaultsData() {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
    }
}
