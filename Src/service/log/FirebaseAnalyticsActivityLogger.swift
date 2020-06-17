import FirebaseAnalytics
import Foundation

class FirebaseAnalyticsActivityLogger: ActivityLogger {
    func setUserId(id: String?) {
        Analytics.setUserID(id)
    }

    func appEventOccurred(_ event: ActivityEvent, extras: [ActivityEventParamKey: Any]?, average: Double?, from file: String) {
        var extras: [String: Any]? = extras?.mapKeys { key -> String in
            key.firebaseName
        }

        if let average = average {
            if extras == nil {
                extras = [:]
            }

            // Docs for `AnalyticsParameterValue` say you can use a double that is represented as NSNumber.
            extras![AnalyticsParameterValue] = average as NSNumber
        }

        Analytics.logEvent(event.firebaseName, parameters: extras)
    }

    func setUserProperty(_ key: UserPropertyKey, value: String) {
        Analytics.setUserProperty(value, forName: key.firebaseName)
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

    func errorOccurred(_ error: Error) {}
}

extension UserPropertyKey {
    var firebaseName: String {
        rawValue.camelCaseToSnakeCase().lowercased()
    }
}

extension ActivityEvent {
    /**
     Firebase comes with a set of event names that you should use in your app, if it fits your app. In this function we convert our app's custom events to these built-in event names if they exist inside of Firebase's collection.

     https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event
     */
    var firebaseName: String {
        switch self {
        case .login: return AnalyticsEventLogin
        default: return rawValue.camelCaseToSnakeCase().lowercased()
        }
    }
}

extension ActivityEventParamKey {
    /**
     Firebase comes with a set of event names that you should use in your app, if it fits your app. In this function we convert our app's custom events to these built-in event names if they exist inside of Firebase's collection.

     https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Param
     */
    var firebaseName: String {
        switch self {
        case .method: return AnalyticsParameterMethod
        default: return rawValue.camelCaseToSnakeCase().lowercased()
        }
    }
}
