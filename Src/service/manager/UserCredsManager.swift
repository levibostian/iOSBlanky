import Foundation
import KeychainAccess

// sourcery: InjectRegister = "UserCredsManager"
class UserCredsManager {
    private let userAuthTokenKey: String = "userAuthTokenKey"

    private let userManager: UserManager
    private let secureStorage: SecureStorage

    init(userManager: UserManager, secureStorage: SecureStorage) {
        self.userManager = userManager
        self.secureStorage = secureStorage
    }

    func areUserCredsAvailable() -> Bool {
        return authToken != nil
    }

    var authToken: String? {
        get { return secureStorage.getString(userAuthTokenKey) }
        set { secureStorage.set(newValue, key: userAuthTokenKey) }
    }
}
