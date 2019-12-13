import Foundation
@testable import iOSBlanky
import XCTest

class UIBackgroundFetchResultExtensionTests: XCTestCase {
    func test_get_givenEmptyArray_expectNoData() {
        let given: [RefreshResult] = []

        let actual = UIBackgroundFetchResult.get(from: given)

        XCTAssertEqual(actual, .noData)
    }

    func test_get_givenOnlySkippedResults_expectNoData() {
        let given: [RefreshResult] = [.skipped(reason: .cancelled), .skipped(reason: .cancelled)]

        let actual = UIBackgroundFetchResult.get(from: given)

        XCTAssertEqual(actual, .noData)
    }

    func test_get_givenSkippedResultsAndOneNotSkipped_expectNotNoData() {
        let given: [RefreshResult] = [.skipped(reason: .cancelled), .skipped(reason: .cancelled), .successful]

        let actual = UIBackgroundFetchResult.get(from: given)

        XCTAssertNotEqual(actual, .noData)
    }

    func test_get_givenSuccessfulResults_expectNewData() {
        let given: [RefreshResult] = [.successful]

        let actual = UIBackgroundFetchResult.get(from: given)

        XCTAssertEqual(actual, .newData)
    }

    func test_get_givenMoreSuccessfulResultsThenFailed_expectNewData() {
        let given: [RefreshResult] = [.successful, .failedError(error: ErrorForTesting.bar)]

        let actual = UIBackgroundFetchResult.get(from: given)

        XCTAssertEqual(actual, .newData)
    }

    func test_get_givenMoreFailedResultsThenSuccessful_expectFailed() {
        let given: [RefreshResult] = [.successful, .failedError(error: ErrorForTesting.bar), .failedError(error: ErrorForTesting.bar)]

        let actual = UIBackgroundFetchResult.get(from: given)

        XCTAssertEqual(actual, .failed)
    }

    func test_singleResult_givenEmptyArray_expectNoData() {
        let given: [UIBackgroundFetchResult] = []

        let actual = UIBackgroundFetchResult.singleResult(from: given)

        XCTAssertEqual(actual, .noData)
    }

    func test_singleResult_givenArrayWithMoreSuccessful_expectNewData() {
        let given: [UIBackgroundFetchResult] = [.newData, .failed]

        let actual = UIBackgroundFetchResult.singleResult(from: given)

        XCTAssertEqual(actual, .newData)
    }

    func test_singleResult_givenArrayWithMoreFailed_expectFailed() {
        let given: [UIBackgroundFetchResult] = [.newData, .failed, .failed]

        let actual = UIBackgroundFetchResult.singleResult(from: given)

        XCTAssertEqual(actual, .failed)
    }
}
