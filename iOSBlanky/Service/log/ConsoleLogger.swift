//
//  ConsoleLogger.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/17/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

class ConsoleLogger {

    class func d(_ message: String) {
        print("debug: \(message)\n")
    }

    class func e(_ error: Error) {
        print("----------ERROR-----------\n")
        print("description: \(error.localizedDescription)\n")
        print("--------------------------\n")
    }

}
