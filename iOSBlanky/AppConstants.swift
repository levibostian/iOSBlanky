//
//  AppConstants.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 12/28/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import UIKit

class AppConstants {

    #if DEBUG
    static let apiEndpoint: String = "https://api.github.com"
    #else
    static let apiEndpoint: String = "https://api.github.com"
    #endif
    
}
