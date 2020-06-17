import Foundation

protocol UserManager: AutoMockable {
    var userId: Double? { get set }
    var authToken: String? { get set }
    var isLoggedIn: Bool { get }
    func logout()
}

// sourcery: InjectRegister = "UserManager"
class AppUserManager: UserManager {
    private let userAuthTokenKey: String = "userAuthTokenKey"

    private let keyValueStore: KeyValueStorage
    private let secureStorage: SecureStorage

    init(storage: KeyValueStorage, secureStorage: SecureStorage) {
        self.keyValueStore = storage
        self.secureStorage = secureStorage
    }

    var userId: Double? {
        get {
            keyValueStore.double(forKey: .loggedInUserId)
        }
        set {
            keyValueStore.setDouble(newValue, forKey: .loggedInUserId)
        }
    }

    var isLoggedIn: Bool {
        userId != nil &&
            authToken != nil
    }

    var authToken: String? {
        get { secureStorage.getString(userAuthTokenKey) }
        set { secureStorage.set(newValue, key: userAuthTokenKey) }
    }

    func logout() {
        userId = nil
        authToken = nil
    }
}
