import Foundation

/**
 When a 400-600 HTTP status code comes up that is not handled by the app.
 */
class UnhandledHttpResponseError: LocalizedError {
    let message: String

    init(message: String) {
        self.message = message
    }

    var errorDescription: String? {
        return message
    }
}
