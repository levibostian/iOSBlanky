import Foundation
@testable import iOSBlanky
import RxSwift
import Teller
import XCTest

/**
 Tests cannot be written until we can mock DriveRepository.
 */
class RepositorySyncServiceTests: UnitTest {
    var repositorySyncService: RepositorySyncService!

    var loggerMock: ActivityLoggerMock!
    var remoteConfigRepositoryMock: RepositoryMock<RemoteConfigDataSource>!

    override func setUp() {
        remoteConfigRepositoryMock = RepositoryMock(dataSource: DI.shared.remoteConfigDataSource)
        loggerMock = ActivityLoggerMock()

        repositorySyncService = TellerRepositorySyncService(remoteConfigRepository: remoteConfigRepositoryMock, logger: loggerMock)
    }

    func test_syncAll_expectRunAllJobsWithoutForcing() {
        let expectNoForcing = expectation(description: "Expect refresh to be called without forcing")

        remoteConfigRepositoryMock.refreshClosure = { force in
            XCTAssertFalse(force)

            expectNoForcing.fulfill()

            return Single.never()
        }

        repositorySyncService.syncAll { _ in }

        waitForExpectations()
    }

    func test_syncAll_givenRepositoriesComplete_expectCompleteWithResult() {
        let expectToComplete = expectation(description: "Expect sync to complete")
        let expect = [RefreshResult.skipped(reason: .dataNotTooOld)]

        remoteConfigRepositoryMock.refreshClosure = { force in
            Single.just(expect[0])
        }

        repositorySyncService.syncAll { actual in
            XCTAssertEqual(expect, actual)

            expectToComplete.fulfill()
        }

        waitForExpectations()
    }
}
