//
//  NotificationCenterUtil.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/10/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation

class NotificationCenterUtil {
    
    class func removeObserver(observer: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
    
    private class func postNotification(name: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil)
    }
    
    private class func observeNotification(observer: AnyObject, selector: Selector, name: String) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: name, object: nil)
    }
    
}
