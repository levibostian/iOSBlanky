import Foundation
import Moya
import RxSwift

protocol GitHubAPI {
    func getUserRepos(username: String) -> Single<Result<[Repo], Error>>
}

class AppGitHubApi: GitHubAPI {
    fileprivate let moyaProvider: MoyaInstance
    fileprivate let jsonAdapter: JsonAdapter
    fileprivate let responseProcessor: MoyaResponseProcessor

    init(moyaProvider: MoyaInstance, jsonAdapter: JsonAdapter, responseProcessor: MoyaResponseProcessor) {
        self.moyaProvider = moyaProvider
        self.jsonAdapter = jsonAdapter
        self.responseProcessor = responseProcessor
    }

    func getUserRepos(username: GitHubUsername) -> Single<Result<[Repo], Error>> {
        return moyaProvider.rx.request(MultiTarget(GitHubService.getUserRepos(username: username)))
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
