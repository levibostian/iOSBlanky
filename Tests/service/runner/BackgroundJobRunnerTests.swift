@testable import App
import Foundation
import XCTest

class BackgroundJobRunnerTests: UnitTest {
    var backgroundJobRunner: BackgroundJobRunner!

    var loggerMock: ActivityLoggerMock!
    var pendingTasksMock: PendingTasksMock!
    var repositorySyncServiceMock: RepositorySyncServiceMock!

    override func setUp() {
        super.setUp()

        loggerMock = ActivityLoggerMock()
        pendingTasksMock = PendingTasksMock()
        repositorySyncServiceMock = RepositorySyncServiceMock()

        backgroundJobRunner = AppBackgroundJobRunner(logger: loggerMock, pendingTasks: pendingTasksMock, repositorySyncService: repositorySyncServiceMock)
    }

    func test_runPeriodicBackgroundJobs_expectRunsAllExpectedJobs() {
        let expectCompletion = expectation(description: "Expect to complete")
        expectCompletion.expectedFulfillmentCount = 2

        repositorySyncServiceMock.syncAllOnCompleteClosure = { onComplete in
            onComplete([])

            expectCompletion.fulfill()
        }
        pendingTasksMock.runAllTasksReturnValue = .newData

        backgroundJobRunner.runPeriodicBackgroundJobs { _ in
            XCTAssertEqual(self.repositorySyncServiceMock.syncAllOnCompleteCallsCount, 1)
            XCTAssertEqual(self.pendingTasksMock.runAllTasksCallsCount, 1)

            expectCompletion.fulfill()
        }

        waitForExpectations()
    }

    // MARK: - handleDataNotification

    func test_handleDataNotification_givenNoActionFromNotification_expectDoNotSync() {
        let givenDataNotification = DataNotification(topicName: nil)

        let expectCallCompletionHandler = expectation(description: "Expect call completion handler")
        backgroundJobRunner.handleDataNotification(givenDataNotification) { result in
            XCTAssertEqual(result, .noData)

            expectCallCompletionHandler.fulfill()
        }

        waitForExpectations()

        XCTAssertFalse(repositorySyncServiceMock.mockCalled)
    }

    func test_handleDataNotification_givenNotificationWithUpdateProgramsAction_expectForceSyncPrograms() {
        let givenDataNotification = DataNotification(topicName: FcmTopicKeys.filesToDownload.value)

        repositorySyncServiceMock.syncAllOnCompleteClosure = { onComplete in
            onComplete([.successful])
        }

        let expectCallCompletionHandler = expectation(description: "Expect call completion handler")
        backgroundJobRunner.handleDataNotification(givenDataNotification) { _ in
            expectCallCompletionHandler.fulfill()
        }

        waitForExpectations()

        XCTAssertEqual(repositorySyncServiceMock.syncAllOnCompleteCallsCount, 1)
    }
}
