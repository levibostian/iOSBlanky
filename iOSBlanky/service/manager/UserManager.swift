import Foundation

class UserManager {
    private let userIdKey: String = "userIdKey"

    var userId: Int? {
        get {
            let userIdUserDefaults = UserDefaults.standard.integer(forKey: userIdKey)
            return userIdUserDefaults == 0 ? nil : userIdUserDefaults
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userIdKey)
        }
    }

    func isUserLoggedIn() -> Bool {
        return userId != 0
    }
}
