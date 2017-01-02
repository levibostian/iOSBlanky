//
//  DateUtil.swift
//  Pods
//
//  Created by Levi Bostian on 12/29/16.
//
//

import Foundation

public class DateUtil: NSObject {
    
    public class func getSecondsFromTimeInterval(_ timeInterval: TimeInterval) -> Int {
        let timeIntervalDate = Date(timeIntervalSince1970: timeInterval / 1000)
        
        return Int(Date().timeIntervalSince(timeIntervalDate))
    }
    
    public class func getStringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        return dateFormatter.string(from: date)
    }
    
    public class func getDateFromDateString(_ dateString: String?) -> Date? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if dateString != nil {
            return dateFormatter.date(from: dateString!)!
        } else {
            return nil
        }
    }
    
    public class func getDateFromTimeString(_ dateString: String?) -> Date? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        if dateString != nil {
            return dateFormatter.date(from: dateString!)!
        } else {
            return nil
        }
    }
    
}
