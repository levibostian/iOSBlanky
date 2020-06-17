import Foundation

/**
 No need to track screen because firebase does this automatically.

 The functions here are meant to be common between many different types of loggers. This file is meant to be generic enough that all loggers can inherit so there are no specific functions meant for 1 specific logger, as much as we can help it.
 */
protocol ActivityLogger: AutoMockable {
    func setUserId(id: String?)
    // meant for analytics purposes.
    // Note: `average` is meant for firebase analytics only used to track averages. Therefore, it's only good for tracking time/scores/periods of time See: https://firebase.googleblog.com/2017/02/firebase-analytics-quick-tip-value.html
    func appEventOccurred(_ event: ActivityEvent, extras: [ActivityEventParamKey: Any]?, average: Double?, from file: String)
    func setUserProperty(_ key: UserPropertyKey, value: String)

    // meant for debugging purposes only.
    func breadcrumb(_ event: String, extras: [String: Any]?, from file: String)
    func httpRequestEvent(method: String, url: String, reqBody: String?)
    func httpSuccessEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)
    func httpFailEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)
    func errorOccurred(_ error: Error)
}

extension ActivityLogger {
    func appEventOccurred(_ event: ActivityEvent, extras: [ActivityEventParamKey: Any]?, average: Double? = nil, file: StaticString = #file) {
        appEventOccurred(event, extras: extras, average: average, from: "\(file)".pathToFileName())
    }

    func breadcrumb(_ event: String, extras: [String: Any]?, file: StaticString = #file) {
        breadcrumb(event, extras: extras, from: "\(file)".pathToFileName())
    }
}

enum UserPropertyKey: String {
    case highlightValue
}

// Firebase only allows a finite number of parameters to be used. So as long as we limit the number of parameters we use in the whole project, we should be ok.
// These parameters are meant to be generic. Meant to be able to be used across many events.
enum ActivityEventParamKey: String {
    case method
    case id
    case name
    case paidUser // (Bool) If user is a paying customer
    case type
}

enum ActivityEvent: String {
    case login
    case logout
    case didRepoSearch

    // Developer related events that are important to make sure features are working.
    case remoteConfigFetchSuccess
    case remoteConfigFetchFail
    case pushNotificationReceived // data or UI based. provide param
    case pushNotificationTopicSubscribed
    case performBackgroundSync
    case openedDynamicLink
}

// sourcery: InjectRegister = "ActivityLogger"
class AppActivityLogger: ActivityLogger {
    private let loggers: [ActivityLogger]

    init(environment: Environment) {
        var loggersToSet: [ActivityLogger] = [
            ErrorReportingActivityLogger(),
            FirebaseAnalyticsActivityLogger()
        ]

        if environment.isDevelopment {
            loggersToSet.append(DevelopmentActivityLogger())
        }

        self.loggers = loggersToSet
    }

    func setUserId(id: String?) {
        loggers.forEach { $0.setUserId(id: id) }
    }

    func appEventOccurred(_ event: ActivityEvent, extras: [ActivityEventParamKey: Any]?, average: Double?, from file: String) {
        loggers.forEach { $0.appEventOccurred(event, extras: extras, average: average, from: file) }
    }

    func setUserProperty(_ key: UserPropertyKey, value: String) {
        loggers.forEach { $0.setUserProperty(key, value: value) }
    }

    func breadcrumb(_ event: String, extras: [String: Any]?, from file: String) {
        loggers.forEach { $0.breadcrumb(event, extras: extras, from: file) }
    }

    func httpRequestEvent(method: String, url: String, reqBody: String?) {
        loggers.forEach { $0.httpRequestEvent(method: method, url: url, reqBody: reqBody) }
    }

    func httpSuccessEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        loggers.forEach { $0.httpSuccessEvent(method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody) }
    }

    func httpFailEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        loggers.forEach { $0.httpFailEvent(method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody) }
    }

    func errorOccurred(_ error: Error) {
        loggers.forEach { $0.errorOccurred(error) }
    }
}
