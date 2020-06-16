import FirebaseCrashlytics
import Foundation

protocol CrashReportingLogger {
    func identifyUser(userId: String?) // used to identify a user in crashes
    func log(key: String, value: String?) // sets key/value pair
    func nonFatalError(_ error: Error) // logs non-fatal error
    func log(_ message: String) // adds to log
}

// https://firebase.google.com/docs/crashlytics/customize-crash-reports?platform=ios
class CrashlyticsCrashReportingLogger: CrashReportingLogger {
    func log(key: String, value: String?) {
        Crashlytics.crashlytics().setCustomValue(value ?? "(none)", forKey: key)
    }

    func identifyUser(userId: String?) {
        // To logout the user, set to blank string. Resource: https://firebase.google.com/docs/crashlytics/customize-crash-reports?platform=ios#set_user_identifiers
        Crashlytics.crashlytics().setUserID(userId ?? "")
    }

    func nonFatalError(_ error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }

    func log(_ message: String) {
        Crashlytics.crashlytics().log(message)
    }
}
