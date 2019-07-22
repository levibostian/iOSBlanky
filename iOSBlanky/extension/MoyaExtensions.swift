//
//  APITargetsExtensions.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/23/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Foundation
import Moya

typealias MoyaInstance = MoyaProvider<MultiTarget>

extension MoyaProvider {

    class func instance() -> MoyaProvider<MultiTarget> {
        return MoyaProvider<MultiTarget>(plugins: getPlugins(getNetworkActivityPlugin: true))
    }

    class func getPlugins(getNetworkActivityPlugin: Bool) -> [PluginType] {
        let productionPlugins: [PluginType] = [MoyaAppendHeadersPlugin(), HttpLoggerMoyaPlugin()]

        var plugins: [PluginType] = []
        plugins.append(contentsOf: productionPlugins)

        if getNetworkActivityPlugin {
            let networkActivityPlugin: NetworkActivityPlugin = NetworkActivityPlugin(networkActivityClosure: { (change, _) in
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

            plugins.append(networkActivityPlugin)
        }

        return plugins
    }

}

extension Response {

    func isSucccessfulResponse() -> Bool {
        return statusCode >= 200 && statusCode < 300
    }

}
