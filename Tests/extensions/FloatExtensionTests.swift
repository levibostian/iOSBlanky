@testable import App
import Foundation
import XCTest

class FloatExtensionTests: UnitTest {
    // MARK: - roundUp

    func test_roundUp_givenLowFloat_expectRoundUp() {
        let given: Float = 4.1
        let expected: Int = 5

        XCTAssertEqual(given.roundUp, expected)
    }

    func test_roundUp_givenPointZero_expectRoundUp() {
        let given: Float = 4.0
        let expected: Int = 5

        XCTAssertEqual(given.roundUp, expected)
    }

    func test_roundUp_givenHighFloat_expectRoundUp() {
        let given: Float = 4.9
        let expected: Int = 5

        XCTAssertEqual(given.roundUp, expected)
    }

    // MARK: - roundDown

    func test_roundDown_givenLowFloat_expectRoundDown() {
        let given: Float = 4.1
        let expected: Int = 4

        XCTAssertEqual(given.roundDown, expected)
    }

    func test_roundDown_givenPointZero_expectRoundDown() {
        let given: Float = 4.0
        let expected: Int = 4

        XCTAssertEqual(given.roundDown, expected)
    }

    func test_roundDown_givenHighFloat_expectRoundDown() {
        let given: Float = 4.9
        let expected: Int = 4

        XCTAssertEqual(given.roundDown, expected)
    }
}
