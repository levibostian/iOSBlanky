import Foundation
import Moya
import RxSwift

/**
 Specific to Moya, but not specific to a type of API.

 Responsibilities:
 1. Performing HTTP request according to the way that all APIs want the requests to be made.
 2. Abstract away the library (Moya in this instance) as much as possible.
 3. Work with a separate response processor to process the errors and successes
 */
class HttpRequestRunner<SERVICE: TargetType> {
    private let responseProcessor: MoyaResponseProcessor
    private let provider: MoyaProvider<SERVICE>
    private let pendingTasks: PendingTasks

    init(responseProcessor: MoyaResponseProcessor, provider: MoyaProvider<SERVICE>, pendingTasks: PendingTasks) {
        self.responseProcessor = responseProcessor
        self.provider = provider
        self.pendingTasks = pendingTasks
    }

    func request(_ target: SERVICE, preRunPendingTask preRunCollectionId: PendingTaskCollectionId?, extraResponseHandling: @escaping (ProcessedResponse) -> HttpRequestError?) -> Single<Result<ProcessedResponse, HttpRequestError>> {
        let performRequestObservable: Single<Result<ProcessedResponse, HttpRequestError>> = Single.create { observer in
            let cancellableToken = self.provider.request(target) { result in
                switch result {
                case .success(let response):
                    observer(.success(self.responseProcessor.process(response, extraResponseHandling: extraResponseHandling)))
                case .failure(let moyaError):
                    let requestError = self.responseProcessor.process(moyaError)

                    observer(.success(Result.failure(requestError)))
                }
            }

            return Disposables.create {
                cancellableToken.cancel()
            }
        }

        if let preRunCollectionId = preRunCollectionId {
            return pendingTasks.runCollectionTasks(for: preRunCollectionId)
                .flatMap { (pendingTasksRunResult) -> Single<Result<ProcessedResponse, HttpRequestError>> in
                    if let requestError = pendingTasksRunResult.requestError {
                        return Single.just(Result.failure(requestError))
                    }

                    return performRequestObservable
                }
        } else {
            return performRequestObservable
        }
    }
}

typealias GitHubRequestRunner = HttpRequestRunner<GitHubService>
// sourcery: InjectRegister = "GitHubRequestRunner"
// sourcery: InjectCustom
extension GitHubRequestRunner {}

extension DI {
    var gitHubRequestRunner: GitHubRequestRunner {
        return HttpRequestRunner(responseProcessor: inject(.moyaResponseProcessor), provider: inject(.gitHubMoyaProvider), pendingTasks: inject(.pendingTasks))
    }
}
