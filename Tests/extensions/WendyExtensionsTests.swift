@testable import App
import Wendy
import XCTest

class WendyExtensionsTests: XCTestCase {
    func test_requestError_failure_expectMessageIncludesFailureMessage() {
        let givenFailure = ErrorForTesting.bar
        let given = PendingTasksRunnerResult.testing.result(from: [
            TaskRunResult.failure(error: givenFailure)
        ])

        let actual = given.requestError

        if case .user = actual!.fault {
        } else {
            XCTFail()
        }
        XCTAssertEqual(actual?.message, givenFailure.localizedDescription)
        XCTAssertNotNil(actual?.underlyingError)
        XCTAssertTrue(actual?.underlyingError is ErrorForTesting)
    }

    func test_requestError_failure_givenHttpRequestError_expectReceiveIt() {
        let givenFailure = HttpRequestError.developer(message: "error message here", underlyingError: ErrorForTesting.bar)
        let given = PendingTasksRunnerResult.testing.result(from: [
            TaskRunResult.failure(error: givenFailure)
        ])

        let actual = given.requestError

        if case .developer = actual!.fault {
        } else {
            XCTFail()
        }
        XCTAssertEqual(actual?.message, givenFailure.message)
        XCTAssertNotNil(actual?.underlyingError)
        XCTAssertTrue(actual?.underlyingError is ErrorForTesting)
    }

    func test_requestError_skippedUnrelyingError_expectMessage() {
        let givenErrorMessage = "error message"
        let givenFailure = PendingTaskError.testing.get(pendingTask: PendingTaskForTests(), errorId: "error-id", errorMessage: givenErrorMessage, createdAt: Date())
        let given = PendingTasksRunnerResult.testing.result(from: [
            TaskRunResult.skipped(reason: .unresolvedRecordedError(unresolvedError: givenFailure))
        ])

        let actual = given.requestError

        if case .user = actual!.fault {
        } else {
            XCTFail()
        }
        XCTAssertEqual(actual?.message, "Fix error: error message, then try again.")
        XCTAssertNil(actual?.underlyingError)
    }

    func test_requestError_skipped_expectMessage() {
        let given = PendingTasksRunnerResult.testing.result(from: [
            TaskRunResult.skipped(reason: .notReadyToRun)
        ])

        let actual = given.requestError

        if case .user = actual!.fault {
        } else {
            XCTFail()
        }
        XCTAssertNotNil(actual?.message)
        XCTAssertNil(actual?.underlyingError)
    }
}
