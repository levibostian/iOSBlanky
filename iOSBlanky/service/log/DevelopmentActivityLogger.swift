import Foundation

// Meant to be used during development.
class DevelopmentActivityLogger: DebugActivityLogger {
    func identifyUser(id: String?) {
        if let userId = id {
            ConsoleLogger.d("User logged in. Id: \(userId)")
        } else {
            ConsoleLogger.d("User logged out.")
        }
    }

    func logAppEvent(_ message: String, extras: [String: Any]?) {
        ConsoleLogger.d("[APP/EVENT] \(message): Extras: \(extras?.description ?? "(null)")")
    }

    func logDebug(_ message: String, extras: [String: Any]?) {
        ConsoleLogger.d("[APP/DEBUG] \(message): Extras: \(extras?.description ?? "(null)")")
    }

    func logError(_ error: Error) {
        ConsoleLogger.e(error)
        fatalError("Error occurred during development. Get it fixed.") // If an error occurs in development, we need to make sure to stop so we can fix it.
    }
}
