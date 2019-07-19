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
    func identifyUser(userId: String?)
    func logError(_ error: Error)
    func logDebug(_ message: String)
}

class CrashlyticsCrashReportingLogger: CrashReportingLogger {

    func identifyUser(userId: String?) {
        Crashlytics.sharedInstance().setUserIdentifier(userId)
    }

    func logError(_ error: Error) {
        Crashlytics.sharedInstance().recordError(error)
    }

    func logDebug(_ message: String) {
        CLSLogv(message, getVaList([]))
    }

}
