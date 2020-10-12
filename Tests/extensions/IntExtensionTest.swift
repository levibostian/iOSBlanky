@testable import App
import Foundation
import XCTest

class IntExtensionTest: UnitTest {
    // MARK: - negate

    func test_negate_given0_expect0() {
        XCTAssertEqual(0.negated, 0)
    }

    func test_negate_givenNegative_expectPositive() {
        XCTAssertEqual(-10.negated, 10)
    }

    func test_negate_givenPositive_expectNegative() {
        XCTAssertEqual(10.negated, -10)
    }
}
