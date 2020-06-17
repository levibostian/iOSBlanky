import Foundation
import KeychainAccess

protocol SecureStorage {
    func getString(_ key: String) -> String?
    func set(_ value: String?, key: String)
    func deleteAll()
}

// sourcery: InjectRegister = "SecureStorage"
class KeychainAccessSecureStorage: SecureStorage {
    private let keychain = Keychain(service: "\(Bundle.main.bundleIdentifier!)")

    func getString(_ key: String) -> String? {
        try! keychain.get(key)
    }

    func set(_ value: String?, key: String) {
        if let newValue = value {
            try! keychain.set(newValue, key: key)
        } else {
            try! keychain.remove(key)
        }
    }

    func deleteAll() {
        try! keychain.removeAll()
    }
}
