//
//  CrashReportingLogger.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/17/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation
import Crashlytics

protocol CrashReportingLogger {
    func identifyUser(userId: String?) // used to identify a user in crashes
    func log(key: String, value: String?) // sets key/value pair
    func nonFatalError(_ error: Error) // logs non-fatal error
    func log(_ message: String) // adds to log
}

// https://firebase.google.com/docs/crashlytics/customize-crash-reports?platform=ios
class CrashlyticsCrashReportingLogger: CrashReportingLogger {

    func log(key: String, value: String?) {
        Crashlytics.sharedInstance().setValue(value, forKey: key)
    }

    func identifyUser(userId: String?) {
        Crashlytics.sharedInstance().setUserIdentifier(userId)
    }

    func nonFatalError(_ error: Error) {
        Crashlytics.sharedInstance().recordError(error)
    }

    func log(_ message: String) {
        CLSLogv(message, getVaList([]))
    }

}
