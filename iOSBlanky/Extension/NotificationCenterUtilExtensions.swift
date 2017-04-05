//
//  NotificationCenterUtilExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 4/5/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import iOSBoilerplate

extension NotificationCenterUtil {
    
    public class func postUserUnauthorized() {
        postNotification("postUserUnauthorized")
    }
    
    public class func observeUserUnauthorized(_ observer: AnyObject, selector: Selector) {
        observeNotification(observer, selector: selector, name: "postUserUnauthorized")
    }
    
}
