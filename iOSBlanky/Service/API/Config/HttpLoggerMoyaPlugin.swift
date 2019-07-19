//
//  HttpLoggerMoyaPlugin.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/16/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation
import Moya
import Result

class HttpLoggerMoyaPlugin: PluginType {

    fileprivate let ignoreHeaderKeys: [String] = ["Authorization"]

    fileprivate let logger: ActivityLogger = Di.container.activityLogger

    func willSend(_ request: RequestType, target: TargetType) {
        logger.httpEvent(message: logNetworkRequest(request.request as URLRequest?, target: target))
    }

    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if case .success(let response) = result {
            logger.httpEvent(message: logNetworkResponse(response.response, data: response.data, target: target))
        } else {
            logger.httpEvent(message: logNetworkResponse(nil, data: nil, target: target))
        }
    }
}

private extension HttpLoggerMoyaPlugin {

    func logNetworkRequest(_ request: URLRequest?, target: TargetType) -> String {
        var output = "Request \(target.method) \(target.path): "

        if let headers = request?.allHTTPHeaderFields {
            output += "Headers: "
            headers.forEach { (key, value) in
                if !ignoreHeaderKeys.contains(key) {
                    output += "\(key):\(value) "
                }
            }
        }

        return output
    }

    func logNetworkResponse(_ response: HTTPURLResponse?, data: Data?, target: TargetType) -> String {
        guard let response = response else {
            return "Response: There is no response body. Target: \(target)."
        }

        var output = "Response \(target.method) \(target.path): Code: \(response.statusCode) "

        // We only want to log response body if failed.
        if response.statusCode >= 400 {
            if let body = data, let stringBody = String(data: body, encoding: String.Encoding.utf8) {
                output += "Body: \(stringBody)"
            }
        }

        return output
    }
}
