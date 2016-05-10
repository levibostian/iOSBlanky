//
//  NumberUtil.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/10/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation

class NumberUtil {
    
    class func getNumberShortform(number: Int) -> String {
        if number > 1000000 {
            return String(format: "%dM", number / 1000000)
        } else if number > 1000 {
            return String(format: "%dK", number / 1000)
        } else {
            return String(format: "%d", number)
        }
    }
    
}
