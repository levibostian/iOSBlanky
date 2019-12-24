import Foundation

protocol DebugActivityLogger: ActivityLogger {
    func identifyUser(id: String?)
    func logAppEvent(_ message: String, extras: [String: Any]?)
    func logDebug(_ message: String, extras: [String: Any]?)
    func logError(_ error: Error)
}

extension DebugActivityLogger {
    func setUserId(id: String?) {
        identifyUser(id: id)
    }

    func appEventOccurred(_ event: ActivityEvent, extras: [String: Any]?, from file: String) {
        logAppEvent("\(event.description) (from \(file))", extras: extras)
    }

    func breadcrumb(_ event: String, extras: [String: Any]?, from file: String) {
        logDebug("\(event) (from \(file))", extras: extras)
    }

    func httpRequestEvent(method: String, url: String, reqBody: String?) {
        logDebug("Http request-- method: \(method), url: \(url), req body: \(reqBody ?? "(none)")", extras: nil)
    }

    func httpSuccessEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        logDebug("Http response success-- method: \(method), url: \(url), code: \(code), res body: \(resBody ?? "(none)")", extras: nil)
    }

    func httpFailEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        logDebug("Http Response Failed! method: \(method), url: \(url), code: \(code), req headers: \(reqHeaders ?? "(none)"), res headers: \(resHeaders ?? "(none)"), res body: \(resBody ?? "(none)")", extras: nil)
    }

    func errorOccurred(_ error: Error) {
        logError(error)
    }
}
