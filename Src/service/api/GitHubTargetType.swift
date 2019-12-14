import Foundation
import Moya

enum GitHubService {
    case getUserRepos(username: String)
}

extension GitHubService: TargetType {
    var baseURL: URL { return URL(string: Constants.apiEndpoint)! }

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
            return "{}".data(using: .utf8)!
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
