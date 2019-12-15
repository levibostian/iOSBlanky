import Foundation
import RxSwift

protocol KeyValueStorage {
    func integer(forKey key: String) -> Int?
    func set(_ value: Int?, forKey key: String)
    func string(forKey key: String) -> String?
    func set(_ value: String?, forKey key: String)
    // Does not emit when value is nil
    func observeString(forKey key: String) -> Observable<String>
    func deleteAll()
}

// sourcery: InjectRegister = "KeyValueStorage"
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

    func observeString(forKey key: String) -> Observable<String> {
        return userDefaults.rx.observe(String.self, key)
            .filter { (value) -> Bool in
                value != nil
            }.map { (value) -> String in
                value!
            }
    }

    func deleteAll() {
        userDefaults.deleteAll()
    }
}
