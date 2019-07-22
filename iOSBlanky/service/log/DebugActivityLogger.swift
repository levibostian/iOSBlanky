//
//  DebugActivityLogger.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/21/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

class LogHttpFailError: LocalizedError {
    var localizedDescription: String {
        return message
    }

    private let message: String

    init(message: String) {
        self.message = message
    }
}

protocol DebugActivityLogger: ActivityLogger {
    func identifyUser(id: String?)
    func logEvent(tag: String, message: String)
    func logError(_ error: Error)
}

extension DebugActivityLogger {

    func setUserId(id: String?) {
        self.identifyUser(id: id)
    }

    func trackEvent(_ event: ActivityEvent, data: [String: Any]?) {
        logEvent(tag: "Event", message: event.description)
    }

    func httpRequestEvent(method: String, url: String) {
        logEvent(tag: "HttpEvent", message: "Request method: \(method), url: \(url)")
    }

    func httpSuccessEvent(method: String, url: String) {
        logEvent(tag: "HttpEvent", message: "Request success: \(method), url: \(url)")
    }

    func httpFailEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        let message = "Response Failed! method: \(method), url: \(url), code: \(code), req headers: \(reqHeaders ?? "(none)"), res headers: \(resHeaders ?? "(none)"), res body: \(resBody ?? "(none)")"

        // Log event and error so we capture it well.
        logEvent(tag: "HttpEvent", message: message)
        logError(LogHttpFailError(message: message))
    }

    func errorOccurred(_ error: Error) {
        logError(error)
    }

}
