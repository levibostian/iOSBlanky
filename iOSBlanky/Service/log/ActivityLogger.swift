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
    func userPerformedAction(event: ActivityEvent, data: [String: Any]?)
    func httpEvent(message: String)
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

    private let loggers: [ActivityLogger] = [ErrorReportingActivityLogger(),
                                             DevelopmentActivityLogger(),
                                             FirebaseAnalyticsActivityLogger()]

    func setUserId(id: String?) {
        loggers.forEach({ $0.setUserId(id: id) })
    }

    func userPerformedAction(event: ActivityEvent, data: [String: Any]?) {
        loggers.forEach({ $0.userPerformedAction(event: event, data: data) })
    }

    func httpEvent(message: String) {
        loggers.forEach({ $0.httpEvent(message: message) })
    }

}
