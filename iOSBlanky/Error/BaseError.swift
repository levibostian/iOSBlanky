//
//  BaseError.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation

enum BaseError: Error {
    case Error(NSError)
    
    var error: NSError {
        switch self {
        case .Error(let error): return error
        }
    }
    
    static func generateNSError(code: Int = -1, userInfo: [AnyHashable: Any] = [:]) -> NSError {
        if let domain = Bundle.main.bundleIdentifier {
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } else {
            return NSError(domain: "unknown", code: code, userInfo: userInfo)
        }
    }
    
}
