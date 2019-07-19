//
//  DevelopmentActivityLogger.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/17/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

class DevelopmentActivityLogger: ActivityLogger {

    func setUserId(id: String?) {
        if let userId = id {
            ConsoleLogger.d("User logged in. Id: \(userId)")
        } else {
            ConsoleLogger.d("User logged out.")
        }
    }

    func userPerformedAction(event: ActivityEvent, data: [String: Any]?) {
        ConsoleLogger.d("Performed action: \(event.description), data: \(data?.description ?? "(none)")")
    }

    func httpEvent(message: String) {
        ConsoleLogger.d("Http event: \(message)")
    }

}
