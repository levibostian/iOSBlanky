//
//  UserCredsManager.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import KeychainAccess

enum UserCredsManagerError: Error, CustomStringConvertible {
    case credsValueNotSet
    
    var description: String {
        switch self {
        case .credsValueNotSet:
            return "You forgot to set some values in UserCredsManager.Editor."
        }
    }
}

class UserCredsManager {
    
    fileprivate static let userAuthTokenKey: String = "userAuthTokenKey"
    
    fileprivate static let keychain = Keychain(service: "com.curiosityio.iosblanky")
    
    class func areUserCredsAvailable() throws -> Bool {
        return try getAuthToken() != nil
    }
    
    class func clearUserData() throws {
        try keychain.remove(userAuthTokenKey)
    }
    
    class func getAuthToken() throws -> String? {
        return try keychain.getString(userAuthTokenKey)
    }
    
    class func saveAuthToken(_ authToken: String?) throws {
        if let authToken = authToken {
            try keychain.set(authToken, key: userAuthTokenKey)
        }
    }
    
    class Editor {
        
        fileprivate var authToken: String?
        
        init() {
        }
        
        func setAuthToken(_ authToken: String?) -> Self {
            self.authToken = authToken
            
            return self
        }
        
        func commit() throws {
            guard let authToken = authToken else {
                throw UserCredsManagerError.credsValueNotSet
            }
            
            try UserCredsManager.saveAuthToken(authToken)
        }
    }
    
}
