import Foundation
import Moya
import Result

class HttpLoggerMoyaPlugin: PluginType {
    fileprivate let ignoreHeaderKeys: [String] = ["Authorization"]

    fileprivate let logger: ActivityLogger

    init(logger: ActivityLogger) {
        self.logger = logger
    }

    func willSend(_ request: RequestType, target: TargetType) {
        logger.httpRequestEvent(method: request.request!.httpMethod!, url: request.request!.url!.absoluteString)
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            let method = response.request!.httpMethod!
            let url = response.request!.url!.absoluteString
            let reqHeaders = response.request!.allHTTPHeaderFields?.description
            let resHeaders = response.response?.allHeaderFields.description
            let resBody = String(decoding: response.data, as: UTF8.self)

            if response.isSucccessfulResponse() {
                logger.httpSuccessEvent(method: method, url: url, code: response.statusCode, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody)
            } else {
                logger.httpFailEvent(method: method, url: url, code: response.statusCode, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody)
            }
        case .failure(let error):
            logger.errorOccurred(error)
        }
    }
}

private extension HttpLoggerMoyaPlugin {
    func logNetworkRequest(_ request: URLRequest?, target: TargetType) -> String {
        var output = "Request \(target.method) \(target.path): "

        if let headers = request?.allHTTPHeaderFields {
            output += "Headers: "
            headers.forEach { key, value in
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
//        if response.statusCode >= 400 {
        if let body = data, let stringBody = String(data: body, encoding: String.Encoding.utf8) {
            output += "Body: \(stringBody)"
        }
//        }

        return output
    }
}
