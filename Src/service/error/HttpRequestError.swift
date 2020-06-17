import Foundation

struct HttpRequestError: Swift.Error {
    // Be able to determine who needs to fix this error
    let fault: FaultType
    // Human readable message to show to user of app.
    let message: String
    // Optional error which is intended for UI of app to respond to an error in a specific way such as "ConflictResponseError". Check if underlying error is of a type of error and if so, do something special in the app.
    let underlyingError: Error?

    private init(fault: FaultType, message: String, underlyingError: Error?) {
        self.fault = fault
        self.message = message
        self.underlyingError = underlyingError
    }

    static func developer(message: String, underlyingError: Error) -> HttpRequestError {
        HttpRequestError(fault: .developer(underlyingError: underlyingError), message: message, underlyingError: underlyingError)
    }

    static func network(message: String) -> HttpRequestError {
        HttpRequestError(fault: .network, message: message, underlyingError: nil)
    }

    static func user(message: String, underlyingError: Error?) -> HttpRequestError {
        HttpRequestError(fault: .user(underlyingError: underlyingError), message: message, underlyingError: underlyingError)
    }

    enum FaultType: Equatable {
        // Errors here for convenience so you don't need to force cast them.
        case developer(underlyingError: Error)
        case user(underlyingError: Error?)
        case network

        static func == (lhs: HttpRequestError.FaultType, rhs: HttpRequestError.FaultType) -> Bool {
            switch (lhs, rhs) {
            case (.developer, .developer): return true
            case (.user, .user): return true
            case (.network, .network): return true
            default: return false
            }
        }
    }
}

extension HttpRequestError: LocalizedError {
    var errorDescription: String? {
        localizedDescription
    }

    var localizedDescription: String {
        message
    }
}

extension HttpRequestError {
    static func getNoInternetConnection() -> HttpRequestError {
        HttpRequestError.network(message: Strings.noInternetConnectionErrorMessage.localized)
    }

    static func getInternetConnectionIssue() -> HttpRequestError {
        HttpRequestError.network(message: Strings.networkConnectionIssueErrorMessage.localized)
    }
}
