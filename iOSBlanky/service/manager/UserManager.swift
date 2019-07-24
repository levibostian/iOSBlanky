import Foundation

class UserManager {

    private let userIdKey: String = "userIdKey"
    private let keyValueStore: KeyValueStorage

    init(storage: KeyValueStorage) {
        self.keyValueStore = storage
    }

    var userId: Int? {
        get {
            return keyValueStore.integer(forKey: userIdKey)
        }
        set {
            keyValueStore.set(newValue, forKey: userIdKey)
        }
    }

    func isUserLoggedIn() -> Bool {
        return userId != 0
    }
}
