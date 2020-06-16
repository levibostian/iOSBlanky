import Foundation
import Moya
import RxSwift

protocol GitHubAPI: AutoMockable {
    func getUserRepos(username: GitHubUsername) -> Single<Result<[Repo], HttpRequestError>>
}

/**
 Responsibilities:
 1. Log to logger if errors
 2. Call eventbus if needed
 3. Catch extra errors beyond basics such as 500 status code that Request Runner catches for you

 This is the default functionality of the GitHub API. Do it all here.
 */
// sourcery: InjectRegister = "GitHubAPI"
class AppGitHubApi: GitHubAPI {
    fileprivate let jsonAdapter: JsonAdapter
    fileprivate let requestRunner: GitHubRequestRunner
    fileprivate let activityLogger: ActivityLogger
    fileprivate let eventBus: EventBus

    init(requestRunner: GitHubRequestRunner, jsonAdapter: JsonAdapter, activityLogger: ActivityLogger, eventBus: EventBus) {
        self.requestRunner = requestRunner
        self.jsonAdapter = jsonAdapter
        self.activityLogger = activityLogger
        self.eventBus = eventBus
    }

    func getUserRepos(username: GitHubUsername) -> Single<Result<[Repo], HttpRequestError>> {
        request(.getUserRepos(username: username),
                preRunPendingTask: .getUserRepos,
                successHandler: { (processedResponse) -> [Repo] in
                    self.jsonAdapter.fromJsonArray(processedResponse.data)
                }, extraErrorHandling: { (response) -> HttpRequestError? in
                    if response.statusCode == 404 {
                        return HttpRequestError(fault: .user, message: Strings.userHasNoGithubRepos.localized, underlyingError: nil)
                    }
                    return nil
        })
    }

    fileprivate func request<T: Any>(_ target: GitHubService, preRunPendingTask: PendingTaskCollectionId, successHandler: @escaping (ProcessedResponse) -> T, extraErrorHandling: @escaping (ProcessedResponse) -> HttpRequestError?) -> Single<Result<T, HttpRequestError>> {
        requestRunner.request(target, preRunPendingTask: preRunPendingTask, extraResponseHandling: { processedResponse -> HttpRequestError? in
            switch processedResponse.statusCode {
            case 401:
                self.eventBus.post(.logout, extras: nil)
                // No need to give a message for error as the eventbus post should restart the app and ask for a login.
                return HttpRequestError(fault: .network, message: "", underlyingError: nil)
            default: return extraErrorHandling(processedResponse)
            }
        })
            .map { (result) -> Result<ProcessedResponse, HttpRequestError> in
                switch result {
                case .failure(let requestError):
                    switch requestError.fault {
                    case .developer:
                        self.activityLogger.errorOccurred(requestError)
                    default: break
                    }
                default: break
                }

                return result
            }.map { (result) -> Result<T, HttpRequestError> in
                switch result {
                case .success(let processedResponse):
                    return Result.success(successHandler(processedResponse))
                case .failure(let requestError):
                    return Result.failure(requestError)
                }
            }
    }
}
