//
//  DateUtil.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/10/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation

class DateUtil: NSObject {
    
    class func getSecondsFromTimeInterval(_ timeInterval: TimeInterval) -> Int {
        let timeIntervalDate = Date(timeIntervalSince1970: timeInterval / 1000)
        
        return Int(Date().timeIntervalSince(timeIntervalDate))
    }
    
    class func getStringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        return dateFormatter.string(from: date)
    }
    
    class func getDateFromDateString(_ dateString: String?) -> Date? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if dateString != nil {
            return dateFormatter.date(from: dateString!)!
        } else {
            return nil
        }
    }
    
    class func getDateFromTimeString(_ dateString: String?) -> Date? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        if dateString != nil {
            return dateFormatter.date(from: dateString!)!
        } else {
            return nil
        }
    }
    
}
