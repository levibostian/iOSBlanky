//
//  UrlUtil.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import UIKit

class UrlUtil {
    
    class func openWebpage(_ url: String) {
        if let openUrl = URL(string: url) {
            UIApplication.shared.openURL(openUrl)
        }
    }
    
}
