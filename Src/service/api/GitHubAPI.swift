import Foundation
import Moya
import RxSwift

protocol GitHubAPI: AutoMockable {
    func getUserRepos(username: String) -> Single<Result<[Repo], Error>>
}

// sourcery: InjectRegister = "GitHubAPI"
class AppGitHubApi: GitHubAPI {
    fileprivate let moyaProvider: GitHubMoyaProvider
    fileprivate let jsonAdapter: JsonAdapter
    fileprivate let responseProcessor: MoyaResponseProcessor

    init(gitHubMoyaProvider: GitHubMoyaProvider, jsonAdapter: JsonAdapter, responseProcessor: MoyaResponseProcessor) {
        self.moyaProvider = gitHubMoyaProvider
        self.jsonAdapter = jsonAdapter
        self.responseProcessor = responseProcessor
    }

    func getUserRepos(username: GitHubUsername) -> Single<Result<[Repo], Error>> {
        return moyaProvider.rx.request(GitHubService.getUserRepos(username: username))
            .map { (response) -> ProcessedResponse in
                self.responseProcessor.process(response, extraResponseHandling: { (statusCode) -> Error? in
                    if statusCode == 404 {
                        return ResposApiError.usernameDoesNotExist(username: username)
                    }
                    return nil
                })
            }.map { (processedResponse) -> Result<[Repo], Error> in
                if let error = processedResponse.error {
                    return Result.failure(error)
                }
                return Result.success(self.jsonAdapter.fromJsonArray(processedResponse.response!.data))
            }.catchError { (error) -> Single<Result<[Repo], Error>> in
                Single.just(Result.failure(self.responseProcessor.process(error).error!))
            }
    }
}
