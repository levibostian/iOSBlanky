@testable import App
import Boquila
import Foundation
import XCTest

class ViewDataProviderTest: UnitTest {
    private var viewDataProvider: ViewDataProvider!

    override func setUp() {
        super.setUp()

        viewDataProvider = AppViewDataProvider(remoteConfigAdapter: remoteConfigAdapter)
    }

    func test_loginViewController_expectGetDefault() {
        XCTAssertNotNil(viewDataProvider.loginViewController)
    }
}
