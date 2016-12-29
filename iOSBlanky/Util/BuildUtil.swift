//
//  BuildUtil.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation

class BuildUtil {
    
    class func getVersionName() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String // swiftlint:disable:this force_cast
    }
    
}
