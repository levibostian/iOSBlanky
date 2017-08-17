//
//  MacAlamofireConfig.swift
//  Pods
//
//  Created by Levi Bostian on 8/11/17.
//
//

import Foundation
import Alamofire

public protocol MacAlamofireConfig {
    
    func getRequestAdapter() -> RequestAdapter?
    func getUrlSessionConfig() -> URLSessionConfiguration?
    
}
