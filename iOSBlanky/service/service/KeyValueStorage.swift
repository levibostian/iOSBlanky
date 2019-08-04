import Foundation

protocol KeyValueStorage {
    func integer(forKey key: String) -> Int?
    func set(_ value: Int?, forKey key: String)
    func string(forKey key: String) -> String?
    func set(_ value: String?, forKey key: String)
}

class UserDefaultsKeyValueStorage: KeyValueStorage {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func integer(forKey key: String) -> Int? {
        let value = userDefaults.integer(forKey: key)
        return value == 0 ? nil : value
    }

    func set(_ value: Int?, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    func string(forKey key: String) -> String? {
        return userDefaults.string(forKey: key)
    }

    func set(_ value: String?, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
}
