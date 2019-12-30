import FirebaseAnalytics
import Foundation

class FirebaseAnalyticsActivityLogger: ActivityLogger {
    func setUserId(id: String?) {
        Analytics.setUserID(id)
    }

    func appEventOccurred(_ event: ActivityEvent, extras: [String: Any]?, from file: String) {
        let eventName = Util.makeEventNameAppropriate(event.description)

        Analytics.logEvent(eventName, parameters: extras)
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
        // Logged event so we can send a notification to people who have encountered an issue when we have new updates for them.
        appEventOccurred(.errorOccurred, extras: nil)
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
