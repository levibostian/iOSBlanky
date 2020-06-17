import Foundation

class ErrorReportingActivityLogger: DebugActivityLogger {
    fileprivate let logger: CrashReportingLogger = CrashlyticsCrashReportingLogger()

    func identifyUser(id: String?) {
        logger.identifyUser(userId: id)
    }

    func logAppEvent(_ message: String, extras: [String: Any]?) {
        logger.log("\(message) -- Extras: \(extras?.description ?? "(null)")")
    }

    func setUserProperty(_ key: UserPropertyKey, value: String) {
        logger.log("property: \(key.rawValue): \(value)")
    }

    func logDebug(_ message: String, extras: [String: Any]?) {
        logger.log("\(message) -- Extras: \(extras?.description ?? "(null)")")
    }

    func logError(_ error: Error) {
        logger.nonFatalError(error)
    }
}
