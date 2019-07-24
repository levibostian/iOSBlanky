import Foundation
import KeychainAccess

class UserCredsManager {
    private let userAuthTokenKey: String = "userAuthTokenKey"

    private var keychain: Keychain? {
        if let loggedInUserId = self.userManager.userId {
            return Keychain(service: String(format: "%@ %d", Bundle.main.bundleIdentifier!, loggedInUserId))
        }
        return nil
    }

    private let userManager: UserManager

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
