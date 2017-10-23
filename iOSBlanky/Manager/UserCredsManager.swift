//
//  UserCredsManager.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import KeychainAccess

class UserCredsManager {
    
    fileprivate static let userAuthTokenKey: String = "userAuthTokenKey"
    fileprivate static var keychain: Keychain? {
        get {
            if let loggedInUserId = UserManager.userId {
                return Keychain(service: String.init(format: "%@ %d", Bundle.main.bundleIdentifier!, loggedInUserId))
            }
            return nil
        }
    }
    
    class func areUserCredsAvailable() -> Bool { return authToken != nil }
    
    static var authToken: String? {
        get { return try! keychain?.getString(userAuthTokenKey) }
        set { if let newValue = newValue { try! keychain?.set(newValue, key: userAuthTokenKey) } }
    }
    
}
