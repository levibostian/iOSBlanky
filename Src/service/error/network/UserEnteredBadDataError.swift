import Foundation

/**
 A 403 HTTP response code.
 */
class UserEnteredBadDataError: LocalizedError {
    let message: String

    init(message: String) {
        self.message = message
    }

    var errorDescription: String? {
        return message
    }
}
