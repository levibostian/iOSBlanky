import Foundation
@testable import iOSBlanky
import XCTest

class StringExtensionTests: XCTestCase {
    func test_pathToFileName_givenFileNameOnly_expectSameResult() {
        let given = "FileName.png"

        let actual = given.pathToFileName()

        XCTAssertEqual(actual.count, given.count)
    }

    func test_pathToFileName_givenPath_expectGetFileName() {
        let given = "/Users/Path/To/FileName.png"

        let actual = given.pathToFileName()

        XCTAssertEqual(actual, "FileName.png")
    }

    func test_capitalizingFirstLetter_givenNoCaps_expectCapitalizeFirstLetter() {
        let given = "given"
        let expected = "Given"

        let actual = given.capitalizingFirstLetter()

        XCTAssertEqual(actual, expected)
    }

    func test_capitalizingFirstLetter_givenAllCaps_expectCapitalizeFirstLetter() {
        let given = "GIVEN"
        let expected = "Given"

        let actual = given.capitalizingFirstLetter()

        XCTAssertEqual(actual, expected)
    }

    func test_capitalizingFirstLetter_givenAlreadyCapsFirstLetter_expectEqual() {
        let given = "Given"
        let expected = "Given"

        let actual = given.capitalizingFirstLetter()

        XCTAssertEqual(actual, expected)
    }

    func test_capitalizeFirstLetter_expectMutate() {
        var given = "GIVEN"
        let expected = "Given"

        given.capitalizeFirstLetter()

        XCTAssertEqual(expected, given)
    }
}
