//
//  FirebaseAnalyticsActivityLogger.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/17/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class FirebaseAnalyticsActivityLogger: ActivityLogger {

    func setUserId(id: String?) {
        Analytics.setUserID(id)
    }

    func trackEvent(_ event: ActivityEvent, data: [String: Any]?) {
        Analytics.logEvent(event.description, parameters: data)
    }

    func httpRequestEvent(method: String, url: String) {
        // No need to log this to analytics.
    }

    func httpSuccessEvent(method: String, url: String) {
        // No need to log this to analytics.
    }

    func httpFailEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        // No need to log this to analytics.
    }

    func errorOccurred(_ error: Error) {
        // No need to log this to analytics.
    }

}
