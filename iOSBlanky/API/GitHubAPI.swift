//
//  GitHubAPI.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/3/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

enum GitHubService {
    case getUserRepos(username: String)
}

extension GitHubService: TargetType {
    
    var baseURL: URL { return URL(string: AppConstants.apiEndpoint)! }
    
    var path: String {
        switch self {
        case .getUserRepos(let username):
            return "/users/\(username)/repos"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getUserRepos:
            return .get
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .getUserRepos:
            return nil
        }
    }
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getUserRepos:
            return URLEncoding.default
        }
    }
    var sampleData: Data {
        switch self {
        case .getUserRepos:
            return "{\"id\": 1, \"first_name\": \"Levi\", \"last_name\": \"Bostian\"}".data(using: .utf8)!
        }
    }
    var headers: [String: String]? {
        return nil
    }
    var task: Task {
        switch self {
        case .getUserRepos:
            return Task.requestPlain
        }
    }
}
