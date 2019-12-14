import Moya

struct MoyaAppendHeadersPlugin: PluginType {
    fileprivate let userCredsManager: UserCredsManager

    init(userCredsManager: UserCredsManager) {
        self.userCredsManager = userCredsManager
    }

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let urlString = request.url?.absoluteString, urlString.hasPrefix(Constants.apiEndpoint) {
            if let authToken = userCredsManager.authToken {
                request.setValue(String(format: "Bearer %@", authToken), forHTTPHeaderField: "Authorization")
            }
        }

        request.setValue("accept-version", forHTTPHeaderField: Constants.apiVersion)

        return request
    }

    func didReceive(_ result: Result<Moya.Response, Moya.MoyaError>, target: TargetType) {}
}
