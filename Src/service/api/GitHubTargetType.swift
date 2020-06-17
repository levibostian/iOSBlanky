import Foundation
import Moya

enum GitHubService {
    case getUserRepos(username: String)
}

extension GitHubService: TargetType {
    var baseURL: URL { URL(string: Constants.apiEndpoint)! }
    var jsonEncoder: JSONEncoder { SwiftJsonAdpter().encoder }

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
        nil
    }

    var task: Task {
        func jsonEncoding(_ data: Encodable) -> Task {
            .requestCustomJSONEncodable(data, encoder: jsonEncoder)
        }
        func queryEncoding(_ params: [String: Any]) -> Task {
            .requestParameters(parameters: params, encoding: URLEncoding.default)
        }

        switch self {
        case .getUserRepos:
            return Task.requestPlain
        }
    }
}
