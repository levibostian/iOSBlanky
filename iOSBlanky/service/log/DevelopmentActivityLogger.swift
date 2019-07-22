//
//  DevelopmentActivityLogger.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/17/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

// Meant to be used during development.
class DevelopmentActivityLogger: DebugActivityLogger {

    func identifyUser(id: String?) {
        if let userId = id {
            ConsoleLogger.d("User logged in. Id: \(userId)")
        } else {
            ConsoleLogger.d("User logged out.")
        }
    }

    func logEvent(tag: String, message: String) {
        ConsoleLogger.d("\(tag): \(message)")
    }

    func logError(_ error: Error) {
        ConsoleLogger.e(error)
        fatalError("Error occurred during development. Get it fixed.") // If an error occurs in development, we need to make sure to stop so we can fix it.
    }

}
