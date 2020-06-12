import Wendy
import XCTest

class WendyExtensionsTests: XCTestCase {
    func test_requestError_failure_expectMessageIncludesFailureMessage() {
        let givenFailure = ErrorForTesting.bar
        let given = PendingTasksRunnerResult.testing.result(from: [
            TaskRunResult.failure(error: givenFailure)
        ])

        let actual = given.requestError

        XCTAssertEqual(actual?.fault, .user)
        XCTAssertEqual(actual?.message, givenFailure.localizedDescription)
        XCTAssertNotNil(actual?.underlyingError)
        XCTAssertTrue(actual?.underlyingError is ErrorForTesting)
    }

    func test_requestError_failure_givenHttpRequestError_expectReceiveIt() {
        let givenFailure = HttpRequestError(fault: .developer, message: "error message here", underlyingError: ErrorForTesting.bar)
        let given = PendingTasksRunnerResult.testing.result(from: [
            TaskRunResult.failure(error: givenFailure)
        ])

        let actual = given.requestError

        XCTAssertEqual(actual?.fault, givenFailure.fault)
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

        XCTAssertEqual(actual?.fault, .user)
        XCTAssertEqual(actual?.message, "Fix error: error message, then try again.")
        XCTAssertNil(actual?.underlyingError)
    }

    func test_requestError_skipped_expectMessage() {
        let given = PendingTasksRunnerResult.testing.result(from: [
            TaskRunResult.skipped(reason: .notReadyToRun)
        ])

        let actual = given.requestError

        XCTAssertEqual(actual?.fault, .user)
        XCTAssertNotNil(actual?.message)
        XCTAssertNil(actual?.underlyingError)
    }
}
