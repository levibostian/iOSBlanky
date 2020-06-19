@testable import App
import Foundation
import XCTest

class ArrayExtensionTests: XCTestCase {
    // MARK: - insertOrLast

    func test_insertOrLast_givenEmptyArray_expectNewElementOnlyItemOfResult() {
        var given: [String] = []
        let newElement = "new element"
        let expected: [String] = [newElement]

        given.insertOrLast(newElement, at: 0)
        let actual = given

        XCTAssertEqual(actual, expected)
    }

    func test_insertOrLast_givenIndexLargerThenLengthOfArray_expectNewElementAddedToEnd() {
        var given: [String] = [
            "existing 1",
            "existing 2"
        ]
        let newElement = "new element"
        let expected: [String] = [
            given[0],
            given[1],
            newElement
        ]

        given.insertOrLast(newElement, at: 100)
        let actual = given

        XCTAssertEqual(actual, expected)
    }

    func test_insertOrLast_givenIndexLessThanThenLengthOfArray_expectNewElementAddedToIndexPosition() {
        var given: [String] = [
            "existing 1",
            "existing 2"
        ]
        let newElement = "new element"
        let expected: [String] = [
            given[0],
            newElement,
            given[1]
        ]

        given.insertOrLast(newElement, at: 1)
        let actual = given

        XCTAssertEqual(actual, expected)
    }
}
