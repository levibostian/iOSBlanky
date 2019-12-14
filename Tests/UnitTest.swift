import Foundation
import XCTest

class UnitTest: XCTestCase {
    override func setUp() {
        DI.shared.override(.bundle, value: bundle, forType: Bundle.self)

        super.setUp()
    }

    override func tearDown() {
        TestUtil.tearDown()

        super.tearDown()
    }
}
