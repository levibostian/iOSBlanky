//
//  AppActivityUtil.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/17/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation

/**
 No need to track screen because firebase does this automatically.
 */
protocol ActivityLogger {
    func setUserId(id: String?)
    func trackEvent(_ event: ActivityEvent, data: [String: Any]?)
    func httpRequestEvent(method: String, url: String)
    func httpSuccessEvent(method: String, url: String)
    func httpFailEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)
    func errorOccurred(_ error: Error)
}

enum ActivityEvent {
    case userLoggedIn
    case userLoggedOut
    case userSearchedReposForGitHubUser
}

extension ActivityEvent {

    var description: String {
        switch self {
        case .userLoggedIn: return "User_logged_in"
        case .userLoggedOut: return "User_logged_out"
        case .userSearchedReposForGitHubUser: return "User_searched_repos_for_github_user"
        }
    }

}

class AppActivityLogger: ActivityLogger {

    #if DEBUG
    private let loggers: [ActivityLogger] = [ErrorReportingActivityLogger(),
                                             DevelopmentActivityLogger(),
                                             FirebaseAnalyticsActivityLogger()]
    #else
    private let loggers: [ActivityLogger] = [ErrorReportingActivityLogger(),
                                             FirebaseAnalyticsActivityLogger()]
    #endif

    func setUserId(id: String?) {
        loggers.forEach({ $0.setUserId(id: id) })
    }

    func trackEvent(_ event: ActivityEvent, data: [String: Any]?) {
        loggers.forEach({ $0.trackEvent(event, data: data) })
    }

    func httpRequestEvent(method: String, url: String) {
        loggers.forEach({ $0.httpRequestEvent(method: method, url: url) })
    }

    func httpSuccessEvent(method: String, url: String) {
        loggers.forEach({ $0.httpSuccessEvent(method: method, url: url) })
    }

    func httpFailEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        loggers.forEach({ $0.httpFailEvent(method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody) })
    }

    func errorOccurred(_ error: Error) {
        loggers.forEach({ $0.errorOccurred(error) })
    }

}
