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
    
    fileprivate let userAuthTokenKey: String = "userAuthTokenKey"

    fileprivate var keychain: Keychain? {
        if let loggedInUserId = self.userManager.userId {
            return Keychain(service: String.init(format: "%@ %d", Bundle.main.bundleIdentifier!, loggedInUserId))
        }
        return nil
    }
    fileprivate let userManager: UserManager

    init(userManager: UserManager) {
        self.userManager = userManager
    }
    
    func areUserCredsAvailable() -> Bool {
        return authToken != nil
    }
    
    var authToken: String? {
        get { return try! keychain?.getString(userAuthTokenKey) }
        set { if let newValue = newValue { try! keychain?.set(newValue, key: userAuthTokenKey) } }
    }
    
}
