@testable import App
import Foundation
import RxSwift
import Teller
import XCTest

/**
 Tests cannot be written until we can mock DriveRepository.
 */
class RepositorySyncServiceTests: UnitTest {
    var repositorySyncService: RepositorySyncService!

    var loggerMock: ActivityLoggerMock!
    var reposRepositoryMock: TellerRepositoryMock<ReposDataSource>!

    override func setUp() {
        super.setUp()

        reposRepositoryMock = TellerRepositoryMock(dataSource: DI.shared.reposDataSource)
        loggerMock = ActivityLoggerMock()

        repositorySyncService = TellerRepositorySyncService(reposRepository: reposRepositoryMock, keyValueStorage: keyValueStorage, logger: loggerMock)
    }

    // MARK: - syncAll

    func test_syncAll_expectRunAllJobsWithoutForcing() {
        let expectNoForcing = expectation(description: "Expect refresh to be called without forcing")
        keyValueStorage.setString("username", forKey: .lastUsernameSearch)

        reposRepositoryMock.refreshClosure = { force in
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

        keyValueStorage.setString("username", forKey: .lastUsernameSearch)
        reposRepositoryMock.refreshClosure = { force in
            Single.just(expect[0])
        }

        repositorySyncService.syncAll { actual in
            XCTAssertEqual(expect, actual)

            expectToComplete.fulfill()
        }

        waitForExpectations()
    }

    func test_syncAll_expectSetRequirementsOnRepository() {
        reposRepositoryMock.refreshClosure = { force in
            Single.just(.successful)
        }
        keyValueStorage.setString("username", forKey: .lastUsernameSearch)

        let expectToComplete = expectation(description: "Expect sync to complete")
        repositorySyncService.syncAll { actual in
            XCTAssertNotNil(self.reposRepositoryMock.requirements)

            expectToComplete.fulfill()
        }

        waitForExpectations()
    }

    // MARK: - syncRepos

    func test_refreshRepos_expectCallCompletionHandler() {
        reposRepositoryMock.refreshClosure = { force in
            Single.just(.successful)
        }

        let expectToComplete = expectation(description: "Expect sync to complete")
        repositorySyncService.refreshRepos(onComplete: { actual in
            expectToComplete.fulfill()
        })

        waitForExpectations()
    }

    func test_refreshRepos_expectSetRequirementsOnRepository() {
        reposRepositoryMock.refreshClosure = { force in
            Single.just(.successful)
        }
        keyValueStorage.setString("username", forKey: .lastUsernameSearch)

        let expectToComplete = expectation(description: "Expect sync to complete")
        repositorySyncService.refreshRepos(onComplete: { actual in
            XCTAssertNotNil(self.reposRepositoryMock.requirements)

            expectToComplete.fulfill()
        })

        waitForExpectations()
    }
}
