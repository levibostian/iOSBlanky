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
        var plugins: [PluginType] = []
        plugins.append(MoyaAppendHeadersPlugin())
        
        if getNetworkActivityPlugin { plugins.append(networkActivityPlugin) }
        #if DEBUG
            plugins.append(NetworkLoggerPlugin(verbose: false))
        #endif
        
        return plugins
    }
    
    static let networkActivityPlugin: NetworkActivityPlugin = NetworkActivityPlugin(networkActivityClosure: { (change, _) in
        switch change {
        case .began:
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        case .ended:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    })
    
}
