import Foundation

struct HttpRequestError: Swift.Error {
    // Be able to determine who needs to fix this error
    let fault: FaultType
    // Human readable message to show to user of app.
    let message: String
    // Optional error which is intended for UI of app to respond to an error in a specific way such as "ConflictResponseError". Check if underlying error is of a type of error and if so, do something special in the app.
    let underlyingError: Error?

    enum FaultType {
        case developer
        case user
        case network
    }
}

extension HttpRequestError: LocalizedError {
    var errorDescription: String? {
        return localizedDescription
    }

    var localizedDescription: String {
        return message
    }
}
