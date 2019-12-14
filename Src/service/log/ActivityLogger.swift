import Foundation

/**
 No need to track screen because firebase does this automatically.
 */
protocol ActivityLogger: AutoMockable {
    func setUserId(id: String?)
    // meant for analytics purposes
    func appEventOccurred(_ event: String, extras: [String: Any]?, from file: String)
    // meant for debugging purposes only.
    func breadcrumb(_ event: String, extras: [String: Any]?, from file: String)
    func httpRequestEvent(method: String, url: String, reqBody: String?)
    func httpSuccessEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)
    func httpFailEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)
    func errorOccurred(_ error: Error)
}

extension ActivityLogger {
    func appEventOccurred(_ event: String, extras: [String: Any]?, file: StaticString = #file) {
        appEventOccurred(event, extras: extras, from: "\(file)".pathToFileName())
    }

    func breadcrumb(_ event: String, extras: [String: Any]?, file: StaticString = #file) {
        breadcrumb(event, extras: extras, from: "\(file)".pathToFileName())
    }
}

enum ActivityEvent {
    case userLoggedIn
    case userLoggedOut
    case userSearchedReposForGitHubUser
}

extension ActivityEvent {
    var description: String {
        switch self {
        case .userLoggedIn: return "User_logged_in"
        case .userLoggedOut: return "User_logged_out"
        case .userSearchedReposForGitHubUser: return "User_searched_repos_for_github_user"
        }
    }
}

// sourcery: InjectRegister = "ActivityLogger"
class AppActivityLogger: ActivityLogger {
    private let loggers: [ActivityLogger]

    init(environment: Environment) {
        self.loggers = [
            ErrorReportingActivityLogger(),
            DevelopmentActivityLogger(environment: environment),
            FirebaseAnalyticsActivityLogger()
        ]
    }

    func setUserId(id: String?) {
        loggers.forEach { $0.setUserId(id: id) }
    }

    func appEventOccurred(_ event: String, extras: [String: Any]?, from file: String) {
        let eventName = Util.makeEventNameAppropriate(event)

        loggers.forEach { $0.appEventOccurred(eventName, extras: extras, from: file) }
    }

    func breadcrumb(_ event: String, extras: [String: Any]?, from file: String) {
        let eventName = Util.makeEventNameAppropriate(event)

        loggers.forEach { $0.breadcrumb(eventName, extras: extras, from: file) }
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

    class Util {
        // Only allow letters, numbers, or underscores
        class func makeEventNameAppropriate(_ name: String) -> String {
            let okayChars = Set("abcdefghijklmnopqrstuvwxyz_ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
            let replacementChar = "_"

            var returnName = name
            name.forEach { character in
                let characterString = String(character)

                if !okayChars.contains(character) {
                    returnName = returnName.replacingOccurrences(of: characterString, with: replacementChar)
                }
            }

            return returnName
        }
    }
}
