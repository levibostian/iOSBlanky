//
//  AppConstants.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import UIKit
import iOSBoilerplate

class AppConstants {
    
    static let primaryColor: UIColor = UIColor(hexString: "#FFFFFF")
    
    static let baseWebsiteHost: String = "http://levibostian.com"

    static func getAboutUrl() -> String {
        return baseWebsiteHost + "/about.html"
    }
    
    // TODO
    static func getAppStoreUrl() -> String {
        return ""
    }

    #if DEBUG
    static let apiEndpoint: String = "https://api.github.com"
    #else
    static let apiEndpoint: String = "https://api.github.com"
    #endif
    
}
