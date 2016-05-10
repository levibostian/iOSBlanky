//
//  InfoPListUtil.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/10/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation

class InfoPlistUtil {
    
    class func getValueFromKey(key: String) -> AnyObject? {
        let mainBundle = NSBundle.mainBundle()
        
        return mainBundle.objectForInfoDictionaryKey(key)
    }
    
}
