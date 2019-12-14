import Foundation
@testable import iOSBlanky
import XCTest

class BackgroundJobRunnerTests: XCTestCase {
    var backgroundJobRunner: BackgroundJobRunner!

    var loggerMock: ActivityLoggerMock!
    var pendingTasksMock: PendingTasksMock!
    var repositorySyncServiceMock: RepositorySyncServiceMock!

    override func setUp() {
        loggerMock = ActivityLoggerMock()
        pendingTasksMock = PendingTasksMock()
        repositorySyncServiceMock = RepositorySyncServiceMock()

        backgroundJobRunner = AppBackgroundJobRunner(logger: loggerMock, pendingTasks: pendingTasksMock, repositorySyncService: repositorySyncServiceMock)
    }

    override func tearDown() {
        TestUtil.tearDown()

        super.tearDown()
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
}
