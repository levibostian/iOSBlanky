import Foundation

/**
 A 403 HTTP response code.
 */
class UserEnteredBadDataError: Codable, LocalizedError {
    let errorMessage: String

    init(message: String) {
        self.errorMessage = message
    }

    var errorDescription: String? {
        errorMessage
    }
}
