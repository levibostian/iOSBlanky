//
//  UrlUtil.swift
//  Pods
//
//  Created by Levi Bostian on 12/29/16.
//
//

import Foundation
import UIKit

public class UrlUtil {
    
    public class func openWebpage(_ url: String) {
        if let openUrl = URL(string: url) {
            UIApplication.shared.openURL(openUrl)
        }
    }
    
}
