import Foundation

class ErrorReportingActivityLogger: DebugActivityLogger {
    fileprivate let logger: CrashReportingLogger = CrashlyticsCrashReportingLogger()

    func identifyUser(id: String?) {
        logger.identifyUser(userId: id)
    }

    func logAppEvent(_ message: String, extras: [String: Any]?) {
        logger.log("\(message) -- Extras: \(extras?.description ?? "(null)")")
    }

    func logDebug(_ message: String, extras: [String: Any]?) {
        logger.log("\(message) -- Extras: \(extras?.description ?? "(null)")")
    }

    func logError(_ error: Error) {
        logger.nonFatalError(error)
    }
}
