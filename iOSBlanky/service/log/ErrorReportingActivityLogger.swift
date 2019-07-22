//
//  CrashlyticsActivityUtil.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/17/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

class ErrorReportingActivityLogger: DebugActivityLogger {

    fileprivate let logger: CrashReportingLogger = CrashlyticsCrashReportingLogger()

    func identifyUser(id: String?) {
        logger.identifyUser(userId: id)
    }

    func logEvent(tag: String, message: String) {
        logger.log(key: tag, value: message)
    }

    func logError(_ error: Error) {
        logger.nonFatalError(error)
    }

}
