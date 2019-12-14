import Foundation

/**
 A 500...600 HTTP response code was returned from a network call.
 */
class ResponseServerError: LocalizedError {
    private let message: String

    var errorDescription: String? {
        return message
    }

    init(message: String) {
        self.message = message
    }
}
