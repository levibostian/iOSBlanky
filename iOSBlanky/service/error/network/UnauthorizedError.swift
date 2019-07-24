import Foundation

/**
 HTTP response code was 401.
 */
class UnauthorizedError: LocalizedError {
    private let message: String

    var errorDescription: String? {
        return message
    }

    init(message: String) {
        self.message = message
    }
}
