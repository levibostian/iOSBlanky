import Foundation

// Meant to be used during development.
class DevelopmentActivityLogger: DebugActivityLogger {
    private let consoleLogger = ConsoleLogger()

    func identifyUser(id: String?) {
        consoleLogger.d("[APP/USER_ID] \(id ?? "(null)")")
    }

    func setUserProperty(_ key: UserPropertyKey, value: String) {
        consoleLogger.d("[APP/PROPERTY] \(key.rawValue): \(value)")
    }

    func logAppEvent(_ message: String, extras: [String: Any]?) {
        consoleLogger.d("[APP/EVENT] \(message): Extras: \(extras?.description ?? "(null)")")
    }

    func logDebug(_ message: String, extras: [String: Any]?) {
        consoleLogger.d("[APP/DEBUG] \(message): Extras: \(extras?.description ?? "(null)")")
    }

    func logError(_ error: Error) {
        consoleLogger.e(error)
        fatalError("Error occurred during development. Get it fixed.") // If an error occurs in development, we need to make sure to stop so we can fix it.
    }
}
