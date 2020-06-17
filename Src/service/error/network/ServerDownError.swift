/**
 500-600 network error response
 */
class ServerDownError: Error {
    private let message: String

    var errorDescription: String? {
        message
    }

    init(statusCode: Int) {
        self.message = "Server down. Status: \(statusCode)"
    }
}
