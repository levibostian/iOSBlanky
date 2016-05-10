//
//  NSUserDefaultsUtil.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/10/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation

class NSUserDefaultsUtil {
    
    class func deleteAllUserDefaultsData() {
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
    }
}
