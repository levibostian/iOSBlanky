@testable import App
import Foundation
import RxSwift
import XCTest

class UserManagerIntegrationTests: UnitTest {
    private var userManager: UserManager!

    override func setUp() {
        super.setUp()

        userManager = DI.shared.inject(.userManager)
    }

    func test_givenCleanAppState_expectUserNotLoggedIn() {
        XCTAssertFalse(userManager.isLoggedIn)
    }

    func test_givenOnlySetUserId_expectUserNotLoggedIn() {
        userManager.userId = 1

        XCTAssertFalse(userManager.isLoggedIn)
    }

    func test_givenUserManagerPopulated_expectUserLoggedIn() {
        userManager.userId = 1
        userManager.authToken = "123"

        XCTAssertTrue(userManager.isLoggedIn)
    }
}
