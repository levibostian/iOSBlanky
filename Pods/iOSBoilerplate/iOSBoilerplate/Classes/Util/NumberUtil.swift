//
//  NumberUtil.swift
//  Pods
//
//  Created by Levi Bostian on 12/29/16.
//
//

import Foundation

public class NumberUtil {
    
    public class func getNumberShortform(_ number: Int) -> String {
        if number > 1000000 {
            return String(format: "%dM", number / 1000000)
        } else if number > 1000 {
            return String(format: "%dK", number / 1000)
        } else {
            return String(format: "%d", number)
        }
    }
    
    public class func toAlphabetic(_ alphabetIndex: Int) -> String {
        return String(Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters)[alphabetIndex])
    }
    
}
