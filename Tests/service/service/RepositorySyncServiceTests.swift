import Foundation
@testable import iOSBlanky
import Teller
import XCTest

/**
 Tests cannot be written until we can mock DriveRepository.
 */
class RepositorySyncServiceTests: XCTestCase {
    var repositorySyncService: RepositorySyncService!

    var reposRepositoryMock: ReposRepository!
    var loggerMock: ActivityLoggerMock!

    override func setUp() {
        reposRepositoryMock = RepositoryMock(dataSource: DI.shared.reposDataSource)
        loggerMock = ActivityLoggerMock()

        repositorySyncService = TellerRepositorySyncService(reposRepository: reposRepositoryMock, logger: loggerMock)
    }

    override func tearDown() {
        TestUtil.tearDown()

        super.tearDown()
    }

    func test_syncAll_expectRunAllJobsWithoutForcing() {}

    func test_syncAll_givenRepositoriesComplete_expectCompleteWithResult() {}

    func test_syncDriveUpdate_givenForce_expectValueGetsPassedToRepository() {}

    func test_syncDriveUpdate_givenRepositoryComplete_expectCompleteWithResult() {}
}
