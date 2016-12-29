//
//  LogUtil.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation

// Code currently commented out as CocoaLumberjack and Crashlytics not installed in this project. Turn into extensions? 
class LogUtil {
    
    class func log(_ message: String?) {
        var logMessage = "Log message is nil......."
        
        if let message = message {
            logMessage = message
        }
        
        //DDLogDebug(logMessage)
    }
    
    class func logArgs(_ message: String, args: CVarArg...) {
        //DDLogDebug(String(format: message, arguments: args))
    }
    
    class func logError(_ error: Error) {
        #if DEBUG
            //DDLogDebug(String(format: "ERROR THROWN: %@", error.localizedDescription))
        #else
            //Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: ["description": error.localizedDescription])
        #endif
    }
    
}
