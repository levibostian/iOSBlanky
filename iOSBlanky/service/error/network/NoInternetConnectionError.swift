import Foundation

/**
 Device not connected to Internet.
 */
class NoInternetConnectionError: LocalizedError {
    private let message: String

    var errorDescription: String? {
        return message
    }

    init(message: String) {
        self.message = message
    }
}
