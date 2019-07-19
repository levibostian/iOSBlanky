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

    func userPerformedAction(event: ActivityEvent, data: [String: Any]?) {
        Analytics.logEvent(event.description, parameters: data)
    }

    func httpEvent(message: String) {
        // Ignore. No need to log.
    }

}
