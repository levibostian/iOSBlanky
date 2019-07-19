//
//  APITargetsExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/23/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import Moya

class MoyaPluginProvider {
    
    class func getPlugins(getNetworkActivityPlugin: Bool) -> [PluginType] {
        var plugins: [PluginType] = [MoyaAppendHeadersPlugin(), HttpLoggerMoyaPlugin()]

        if getNetworkActivityPlugin { plugins.append(networkActivityPlugin) }
        
        return plugins
    }
    
    static let networkActivityPlugin: NetworkActivityPlugin = NetworkActivityPlugin(networkActivityClosure: { (change, _) in
        switch change {
        case .began:
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        case .ended:
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    })
    
}
