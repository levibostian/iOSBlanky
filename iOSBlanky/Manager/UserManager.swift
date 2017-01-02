//
//  UserManager.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import iOSBoilerplate

enum UserManagerError: Error, CustomStringConvertible {
    case userValuesNotSet
    
    var description: String {
        switch self {
        case .userValuesNotSet:
            return "You forgot to set some values in UserManager.Editor."
        }
    }
}

class UserManager { // swiftlint:disable:this type_body_length
    
    fileprivate static let userIdKey: String = "userIdKey"
    
    class func clearUserData() throws {
        NSUserDefaultsUtil.deleteAllUserDefaultsData()
    }
    
    class func isUserLoggedIn() -> Bool {
        return getUserId() != 0
    }
    
    class func getUserId() -> Int? {
        return NSUserDefaultsUtil.getInt(userIdKey)
    }
    
    class func saveUserId(_ id: Int) {
        NSUserDefaultsUtil.saveInt(userIdKey, value: id)
    }
    
    class Editor {
        
        fileprivate var id: Int!
        
        init() {
        }
        
        func setId(_ id: Int) -> Self {
            self.id = id
            
            return self
        }
        
        func commit() throws {
            guard let id = id else {
                throw UserManagerError.userValuesNotSet
            }
            
            UserManager.saveUserId(id)
        }
    }
}
