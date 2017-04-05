//
//  LogUtil.swift
//  Pods
//
//  Created by Levi Bostian on 4/4/17.
//
//

import Foundation

class LogUtil {
    
    class func log(_ message: String?) {
        var logMessage = "Log message is nil......."
        
        if let message = message {
            logMessage = message
        }
        
        NSLog(logMessage)
    }
    
    class func logArgs(_ message: String?, args: CVarArg...) {
        var logMessage = "Log message is nil......."
        
        if let message = message {
            logMessage = message
        }
        
        NSLog(logMessage, args)
    }
    
}
