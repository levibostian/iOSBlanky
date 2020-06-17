import Foundation
import RxSwift

protocol UserRepository: AutoMockable {
    func exchangeToken(_ token: String) -> Single<Result<TokenExchangeResponseVo, HttpRequestError>>
}

// sourcery: InjectRegister = "UserRepository"
class AppUserRepository: UserRepository {
    fileprivate let githubApi: GitHubAPI
    fileprivate let jsonAdapter: JsonAdapter

    init(githubApi: GitHubAPI, jsonAdapter: JsonAdapter) {
        self.githubApi = githubApi
        self.jsonAdapter = jsonAdapter
    }

    func exchangeToken(_ token: String) -> Single<Result<TokenExchangeResponseVo, HttpRequestError>> {
        githubApi.exchangeToken(token: token)
    }
}
