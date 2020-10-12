@testable import App
import Foundation
import RxBlocking
import RxSwift
import XCTest

class RxSwiftExtensionTests: XCTestCase {
    func test_singleConcatSyncs_givenEmptyArray_expectEmptyResult() {
        let given: [Single<RefreshResult>] = []

        let actual = try! Single.concat(given).toBlocking().first()!

        XCTAssertTrue(actual.isEmpty)
    }

    func test_singleConcatSyncs_givenOneSync_expectOneResult() {
        let givenRefreshResult = RefreshResult.skipped(reason: .cancelled)
        let given: [Single<RefreshResult>] = [
            Single.just(givenRefreshResult)
        ]

        let actual = try! Single.concat(given).toBlocking().first()!

        XCTAssertEqual(actual.count, given.count)
        XCTAssertEqual(actual[0], givenRefreshResult)
    }

    func test_singleConcatSyncs_givenMultipleSyncs_expectMultipleResults() {
        let givenRefreshResult = RefreshResult.skipped(reason: .cancelled)

        let given: [Single<RefreshResult>] = [
            Single.just(givenRefreshResult),
            Single.just(givenRefreshResult)
        ]

        let actual = try! Single.concat(given).toBlocking().first()!

        XCTAssertEqual(actual.count, given.count)
    }

    func test_singleConcatSyncs_givenMultipleSyncs_expectResultsBackInCorrectOrder() {
        let givenRefreshResult1 = RefreshResult.skipped(reason: .cancelled)
        let givenRefreshResult2 = RefreshResult.skipped(reason: .dataNotTooOld)

        let given: [Single<RefreshResult>] = [
            Single.just(givenRefreshResult1),
            Single.just(givenRefreshResult2)
        ]

        let actual = try! Single.concat(given).toBlocking().first()!

        XCTAssertEqual(actual.count, given.count)
        XCTAssertEqual(actual, [
            givenRefreshResult1,
            givenRefreshResult2
        ])
    }
}
