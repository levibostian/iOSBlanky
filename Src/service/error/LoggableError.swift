import Foundation

/**
 An error type that can be logged for fixing later on. We use crashlytics for logging purposes. Crashlytics uses NSError to log non-fatal errors and groups these errors by the domain *and* code.
 This is why the code has a default because it's assumed that you have a unique title.
 Read more: https://firebase.google.com/docs/crashlytics/customize-crash-reports?platform=ios#log-excepts
 */
class LoggableError {
    /**
     staticTitle means that it's not dynamic.
     */
    static func get(staticTitle: String, extras: [String: String]? = nil, code: Int = 0) -> NSError {
        var userInfo: [String: String] = [:]

        userInfo[NSLocalizedDescriptionKey] = staticTitle

        extras?.forEach { arg in
            userInfo[arg.key] = arg.value
        }

        return NSError(domain: staticTitle, code: code, userInfo: userInfo)
    }
}
