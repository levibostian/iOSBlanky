@testable import App
import Foundation
import RxBlocking
import RxSwift
import XCTest

class GitHubApiTests: UnitTest {
    private var moyaMocker: MoyaProviderMocker<GitHubService>!
    private var loggerMock: ActivityLoggerMock!
    private var eventBusMock: EventBusMock!
    private var pendingTasksMock: PendingTasksMock!

    private var api: GitHubAPI!

    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()

        loggerMock = ActivityLoggerMock()
        eventBusMock = EventBusMock()
        moyaMocker = MoyaProviderMocker()
        pendingTasksMock = PendingTasksMock()

        api = AppGitHubApi(requestRunner: GitHubRequestRunner(responseProcessor: DI.shared.moyaResponseProcessor, provider: moyaMocker.moyaProvider, pendingTasks: pendingTasksMock), jsonAdapter: DI.shared.jsonAdapter, activityLogger: loggerMock, eventBus: eventBusMock, schedulers: schedulers)
    }

    func test_getUserRepos_givenSuccessfulResponse_expectReceiveResponse() {
        pendingTasksMock.runCollectionTasksForReturnValue = Single.just(RunCollectionTasksResult.testing.result(from: []))
        let givenResponse: [Repo] = [Repo.fake.random]

        moyaMocker.queueResponse(200, data: givenResponse)

        let actualResult = try! api.getUserRepos(username: "username")
            .toBlocking()
            .single()

        XCTAssertEqual(try actualResult.get(), givenResponse)
    }

    func test_getUserRepos_given404_expectNoReposUserError() {
        pendingTasksMock.runCollectionTasksForReturnValue = Single.just(RunCollectionTasksResult.testing.result(from: []))
        moyaMocker.queueResponse(404, data: "")

        let actualResult = try! api.getUserRepos(username: "username")
            .toBlocking()
            .single()

        let actualFailure = actualResult.failure as? HttpRequestError
        XCTAssertNotNil(actualFailure)
        if case .user = actualFailure!.fault {
        } else {
            XCTFail()
        }
    }

    func test_given401_expectEventBusPost() {
        pendingTasksMock.runCollectionTasksForReturnValue = Single.just(RunCollectionTasksResult.testing.result(from: []))
        moyaMocker.queueResponse(401, data: "")

        _ = try! api.getUserRepos(username: "username")
            .toBlocking()
            .single()

        XCTAssertEqual(eventBusMock.postExtrasCallsCount, 1)
        XCTAssertEqual(eventBusMock.postExtrasReceivedArguments!.event, .logout)
    }

    func test_givenDeveloperError_expectLogError() {
        pendingTasksMock.runCollectionTasksForReturnValue = Single.just(RunCollectionTasksResult.testing.result(from: []))
        moyaMocker.queueResponse(500, data: "")

        let actualResult = try! api.getUserRepos(username: "username")
            .toBlocking()
            .single()

        let actualFailure = actualResult.failure as? HttpRequestError
        XCTAssertNotNil(actualFailure)
        if case .developer = actualFailure!.fault {
        } else {
            XCTFail()
        }

        XCTAssertEqual(loggerMock.errorOccurredCallsCount, 1)
    }

    func test_givenNetworkError_expectNoLogError() {
        pendingTasksMock.runCollectionTasksForReturnValue = Single.just(RunCollectionTasksResult.testing.result(from: []))
        moyaMocker.queueNetworkError(URLError(.notConnectedToInternet))

        let actualResult = try! api.getUserRepos(username: "username")
            .toBlocking()
            .single()

        let actualFailure = actualResult.failure as? HttpRequestError
        XCTAssertNotNil(actualFailure)
        XCTAssertEqual(actualFailure?.fault, .network)

        XCTAssertFalse(loggerMock.errorOccurredCalled)
    }
}
