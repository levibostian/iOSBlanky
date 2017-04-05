//
//  NSUserDefaultsUtil.swift
//  Pods
//
//  Created by Levi Bostian on 12/29/16.
//
//

import Foundation

public class NSUserDefaultsUtil {
    
    public class func saveDouble(_ key: String, value: Double) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public class func getDouble(_ key: String) -> Double {
        return UserDefaults.standard.double(forKey: key)
    }
    
    public class func saveInt(_ key: String, value: Int) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public class func getInt(_ key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    public class func saveString(_ key: String, value: String) {
        UserDefaults.standard.setValue(value, forKeyPath: key)
    }
    
    public class func getString(_ key: String) -> String? {
        return UserDefaults.standard.object(forKey: key) as? String
    }
    
    public class func saveBool(_ key: String, value: Bool) {
        UserDefaults.standard.setValue(value, forKeyPath: key)
    }
    
    public class func getBool(_ key: String) -> Bool? {
        return UserDefaults.standard.object(forKey: key) as? Bool
    }
    
    public class func deleteAllUserDefaultsData() {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
    }
}
