//
//  InfoPlistUtil.swift
//  Pods
//
//  Created by Levi Bostian on 12/29/16.
//
//

import Foundation

public class InfoPlistUtil {
    
    public class func getValueFromKey(_ key: String) -> AnyObject? {
        let mainBundle = Bundle.main
        
        return mainBundle.object(forInfoDictionaryKey: key) as AnyObject?
    }
    
}
