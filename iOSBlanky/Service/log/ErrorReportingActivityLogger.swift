//
//  CrashlyticsActivityUtil.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/17/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

class ErrorReportingActivityLogger: ActivityLogger {

    fileprivate let logger: CrashReportingLogger = CrashlyticsCrashReportingLogger()

    func setUserId(id: String?) {
        logger.identifyUser(userId: id)
    }

    func userPerformedAction(event: ActivityEvent, data: [String: Any]?) {
        logger.logDebug("Performed action: \(event.description), data: \(data?.description ?? "(none)")")
    }

    func httpEvent(message: String) {
        logger.logDebug("Http event: \(message)")
    }

}
