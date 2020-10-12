@testable import App
import Foundation
import XCTest

class ArrayExtensionTests: XCTestCase {
    // MARK: - chunked

    func test_chunked_givenEmptyArray_expectEmptyResult() {
        let given: [String] = []

        let actual = given.chunked(into: 2)
        let expected: [[String]] = []

        XCTAssertEqual(actual, expected)
    }

    func test_chunked_givenSizeLessGiven_expectGetSameResult() {
        let given: [String] = ["1", "2"]

        let actual = given.chunked(into: 2)
        let expected: [[String]] = [["1", "2"]]

        XCTAssertEqual(actual, expected)
    }

    func test_chunked_givenBiggerArray_expectChunkedResult() {
        let given: [String] = ["1", "2", "3", "4", "5"]

        let actual = given.chunked(into: 2)
        let expected: [[String]] = [["1", "2"], ["3", "4"], ["5"]]

        XCTAssertEqual(actual, expected)
    }

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

    // MARK: - isOddCount

    func test_isOddCount_given0Count_expectFalse() {
        let given: [Int] = []

        XCTAssertFalse(given.isOddCount)
    }

    func test_isOddCount_givenOddCount_expectTrue() {
        let given: [Int] = [1]

        XCTAssertTrue(given.isOddCount)
    }

    func test_isOddCount_givenEvenCount_expectFalse() {
        let given: [Int] = [1, 2]

        XCTAssertFalse(given.isOddCount)
    }

    // MARK: - isEvenCount

    func test_isEvenCount_given0Count_expectTrue() {
        let given: [Int] = []

        XCTAssertTrue(given.isEvenCount)
    }

    func test_isEvenCount_givenOddCount_expectFalse() {
        let given: [Int] = [1]

        XCTAssertFalse(given.isEvenCount)
    }

    func test_isEvenCount_givenEvenCount_expectTrue() {
        let given: [Int] = [1, 2]

        XCTAssertTrue(given.isEvenCount)
    }

    // MARK: - middleElement

    func test_middleElement_givenEmptyArray_expectNil() {
        let given: [Int] = []

        XCTAssertNil(given.middleElement(evenRoundDownMiddle: true))
    }

    func test_middleElement_givenOneItem_expectGetItem() {
        let given: [Int] = [1]

        XCTAssertEqual(given.middleElement(evenRoundDownMiddle: true), 1)
    }

    func test_middleElement_givenOddNumberItems_expectGetMiddleItem() {
        let given: [Int] = [1, 2, 3]

        XCTAssertEqual(given.middleElement(evenRoundDownMiddle: true), 2)
    }

    func test_middleElement_givenEvenNumberItems_givenRoundDown_expectGetMiddleItem() {
        let given: [Int] = [1, 2, 3, 4]

        XCTAssertEqual(given.middleElement(evenRoundDownMiddle: true), 2)
    }

    func test_middleElement_givenEvenNumberItems_givenRoundUp_expectGetMiddleItem() {
        let given: [Int] = [1, 2, 3, 4]

        XCTAssertEqual(given.middleElement(evenRoundDownMiddle: false), 3)
    }
}
