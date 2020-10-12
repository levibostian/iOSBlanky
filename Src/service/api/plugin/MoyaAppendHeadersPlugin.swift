import Moya

struct MoyaAppendHeadersPlugin: PluginType {
    fileprivate let userManager: UserManager

    init(userManager: UserManager) {
        self.userManager = userManager
    }

    func prepare(_ request: URLRequest, target _: TargetType) -> URLRequest {
        var request = request
        if let urlString = request.url?.absoluteString, urlString.hasPrefix(Constants.apiEndpoint) {
            if let authToken = userManager.authToken {
                request.setValue(String(format: "Bearer %@", authToken), forHTTPHeaderField: "Authorization")
            }
        }

        request.setValue(Constants.apiVersion, forHTTPHeaderField: "accept-version")

        return request
    }

    func didReceive(_: Result<Moya.Response, Moya.MoyaError>, target _: TargetType) {}
}
