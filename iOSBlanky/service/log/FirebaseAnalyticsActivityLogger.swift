import FirebaseAnalytics
import Foundation

class FirebaseAnalyticsActivityLogger: ActivityLogger {
    func setUserId(id: String?) {
        Analytics.setUserID(id)
    }

    func appEventOccurred(_ event: String, extras: [String: Any]?, from file: String) {
        Analytics.logEvent(event, parameters: extras)
    }

    func breadcrumb(_ event: String, extras: [String: Any]?, from file: String) {
        // No need to log this to analytics.
    }

    func httpRequestEvent(method: String, url: String, reqBody: String?) {
        // No need to log this to analytics.
    }

    func httpSuccessEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        // No need to log this to analytics.
    }

    func httpFailEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        // No need to log this to analytics.
    }

    func errorOccurred(_ error: Error) {
        // No need to log this to analytics.
    }
}
