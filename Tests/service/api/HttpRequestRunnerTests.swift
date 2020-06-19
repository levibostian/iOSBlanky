@testable import App
import Foundation
import Moya
import RxBlocking
import RxSwift
import Wendy
import XCTest

class HttpRequestRunnerTests: UnitTest {
    private var moyaMocker: MoyaProviderMocker<GitHubService>!

    private var requestRunner: HttpRequestRunner<GitHubService>!
    private var nilResponseExtraErrorHandling: (ProcessedResponse) -> HttpRequestError? = { response in
        nil
    }

    private var pendingTasksMock: PendingTasksMock!

    private var jsonAdapter: JsonAdapter!

    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()
        moyaMocker = MoyaProviderMocker()
        jsonAdapter = DI.shared.jsonAdapter
        pendingTasksMock = PendingTasksMock()

        requestRunner = HttpRequestRunner(responseProcessor: DI.shared.moyaResponseProcessor, provider: moyaMocker.moyaProvider, pendingTasks: pendingTasksMock)
    }

    func test_request_givenRequestError_expectParseError() {
        let givenError = MoyaError.underlying(URLError(.notConnectedToInternet), nil)

        moyaMocker.queueNetworkError(givenError)

        let actualResult = try! requestRunner.request(.getUserRepos(username: ""), preRunPendingTask: nil, extraResponseHandling: nilResponseExtraErrorHandling)
            .toBlocking()
            .single()

        let requestError = actualResult.failure as? HttpRequestError
        XCTAssertNotNil(requestError)
    }

    func test_request_givenRequestSuccess_expectParseResponse() {
        let givenRepos: [Repo] = []

        moyaMocker.queueResponse(200, data: try! jsonAdapter.toJson(givenRepos))

        let actualResult = try! requestRunner.request(.getUserRepos(username: ""), preRunPendingTask: nil, extraResponseHandling: nilResponseExtraErrorHandling)
            .toBlocking()
            .single()

        let requestError = actualResult.failure as? HttpRequestError
        XCTAssertNil(requestError)

        let processedResponse = try! actualResult.get()
        XCTAssertEqual(processedResponse.statusCode, 200)
    }

    func test_request_givenNoRunPendingTaskCollections_expectNotToRunPendingTasks() {
        let givenRepos: [Repo] = []

        moyaMocker.queueResponse(200, data: try! jsonAdapter.toJson(givenRepos))

        _ = try! requestRunner.request(.getUserRepos(username: ""), preRunPendingTask: nil, extraResponseHandling: nilResponseExtraErrorHandling)
            .toBlocking()
            .single()

        XCTAssertFalse(pendingTasksMock.runCollectionTasksForCalled)
    }

    func test_request_givenFailedPendingTasks_expectReturnFailure() {
        pendingTasksMock.runCollectionTasksForReturnValue = Single.just(RunCollectionTasksResult.testing.result(from: [
            TaskRunResult.failure(error: URLError(.notConnectedToInternet))
        ]))

        let actualResult = try! requestRunner.request(.getUserRepos(username: ""), preRunPendingTask: .foo, extraResponseHandling: nilResponseExtraErrorHandling)
            .toBlocking()
            .single()

        XCTAssertEqual(pendingTasksMock.runCollectionTasksForCallsCount, 1)

        let requestError = actualResult.failure as? HttpRequestError
        XCTAssertNotNil(requestError)
        if case .user = requestError!.fault {
        } else {
            XCTFail()
        }

        XCTAssertEqual(moyaMocker.queue.count, 0)
    }

    func test_request_givenSuccessfulPendingTasks_expectHttpRequest() {
        pendingTasksMock.runCollectionTasksForReturnValue = Single.just(RunCollectionTasksResult.testing.result(from: [
            TaskRunResult.successful
        ]))

        let givenRepos: [Repo] = []

        moyaMocker.queueResponse(200, data: try! jsonAdapter.toJson(givenRepos))

        let actualResult = try! requestRunner.request(.getUserRepos(username: ""), preRunPendingTask: .foo, extraResponseHandling: nilResponseExtraErrorHandling)
            .toBlocking()
            .single()

        XCTAssertEqual(pendingTasksMock.runCollectionTasksForCallsCount, 1)

        let requestError = actualResult.failure as? HttpRequestError
        XCTAssertNil(requestError)

        let processedResponse = try! actualResult.get()
        XCTAssertEqual(processedResponse.statusCode, 200)
    }
}
