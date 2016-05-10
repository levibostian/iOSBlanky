//
//  DateUtil.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/10/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation

class DateUtil: NSObject {
    
    class func getSecondsFromTimeInterval(timeInterval: NSTimeInterval) -> Int {
        let timeIntervalDate = NSDate(timeIntervalSince1970: timeInterval / 1000)
        
        return Int(NSDate().timeIntervalSinceDate(timeIntervalDate))
    }
    
    class func getStringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        return dateFormatter.stringFromDate(date)
    }
    
    class func getDateFromDateString(dateString: String?) -> NSDate? {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if dateString != nil {
            return dateFormatter.dateFromString(dateString!)!
        } else {
            return nil
        }
    }
    
    class func getDateFromTimeString(dateString: String?) -> NSDate? {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        if dateString != nil {
            return dateFormatter.dateFromString(dateString!)!
        } else {
            return nil
        }
    }
    
}
