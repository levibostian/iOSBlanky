//
//  SecureStorage.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/24/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation
import KeychainAccess

protocol SecureStorage {
    func getString(_ key: String) -> String?
    func set(_ value: String?, key: String)
}

class KeychainAccessSecureStorage: SecureStorage {

    private var keychain: Keychain? {
        guard let loggedInUserId = self.userManager.userId else {
            return nil
        }

        return Keychain(service: String(format: "%@ %d", Bundle.main.bundleIdentifier!, loggedInUserId))
    }

    private let userManager: UserManager

    init(userManager: UserManager) {
        self.userManager = userManager
    }

    func getString(_ key: String) -> String? {
        return try! keychain?.get(key)
    }

    func set(_ value: String?, key: String) {
        guard let keychain = keychain else {
            fatalError("Keychain cannot be nil to save to it.")
        }

        if let newValue = value {
        try! keychain.set(newValue, key: key)
        } else {
            try! keychain.remove(key)
        }
    }

}
