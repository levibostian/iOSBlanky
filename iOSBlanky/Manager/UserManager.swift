//
//  UserManager.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation

class UserManager { 
    
    fileprivate static let userIdKey: String = "userIdKey"
    
    static var userId: Int? {
        get {
            let userIdUserDefaults = UserDefaults.standard.integer(forKey: userIdKey)
            return userIdUserDefaults == 0 ? nil : userIdUserDefaults
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userIdKey)
        }
    }
    
    class func isUserLoggedIn() -> Bool {
        return userId != 0
    }
    
}
