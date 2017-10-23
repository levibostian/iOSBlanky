//
//  MoyaAppendHeadersPlugin.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 10/23/17.
//  Copyright © 2017 Curiosity IO. All rights reserved.
//

import Moya
import Result

public struct MoyaAppendHeadersPlugin: PluginType {
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let urlString = request.url?.absoluteString, urlString.hasPrefix(AppConstants.apiEndpoint) {
            if let authToken = UserCredsManager.authToken {
                request.setValue(String(format: "Bearer %@", authToken), forHTTPHeaderField: "Authorization")
            }
        }
        return request
    }
    
    public func didReceive(_ result: Result<Moya.Response, Moya.MoyaError>, target: TargetType) {
    }
    
}
