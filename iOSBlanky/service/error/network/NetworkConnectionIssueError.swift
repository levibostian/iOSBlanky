import Foundation

/**
 Device connected to Internet, but no network connection. Or timeout error, socket connection error, etc.
 */
class NetworkConnectionIssueError: LocalizedError {
    private let message: String

    var errorDescription: String? {
        return message
    }

    init(message: String) {
        self.message = message
    }
}
