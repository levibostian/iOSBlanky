@testable import App
import Foundation
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

    func test_percentUrlEncode_givenhttpslink_expectEncodeCorrectly() {
        let given = "https://foo.com?file=name of file.jpg"
        let expected = "https://foo.com?file=name%20of%20file.jpg"

        let actual = given.percentUrlEncode()!

        XCTAssertEqual(actual, expected)
    }

    // MARK: isValidEmail

    func test_isValidEmail_givenEmptyString_expectFalse() {
        let given = ""

        let actual = given.isValidEmail()

        XCTAssertFalse(actual)
    }

    func test_isValidEmail_givenInvalidEmailAddress_expectFalse() {
        let given = "@you.com"

        let actual = given.isValidEmail()

        XCTAssertFalse(actual)
    }

    func test_isValidEmail_givenValidEmailAddress_expectFalse() {
        let given = "you@you.com"

        let actual = given.isValidEmail()

        XCTAssertTrue(actual)
    }

    // MARK: fromStringRepeated

    func test_fromStringRepeated_givenRepeatTimes0_expectEmptyString() {
        XCTAssertEqual(String.fromStringRepeated(string: ".", repeatTimes: 0), "")
    }

    func test_fromStringRepeated_givenSingleCharacter_expectString() {
        XCTAssertEqual(String.fromStringRepeated(string: ".", repeatTimes: 5), ".....")
    }

    func test_fromStringRepeated_givenMultipleCharacters_expectString() {
        XCTAssertEqual(String.fromStringRepeated(string: "ABC", repeatTimes: 3), "ABCABCABC")
    }

    func test_fromStringRepeated_givenRepeatTimes1_expectString() {
        XCTAssertEqual(String.fromStringRepeated(string: ".", repeatTimes: 1), ".")
    }

    func test_fromStringRepeated_givenRepeatTimesX_expectString() {
        XCTAssertEqual(String.fromStringRepeated(string: ".", repeatTimes: 10), "..........")
    }

    // MARK: ellipsis

    func test_ellipsis_givenStringBelowMaxLength_expectNoEllipsis() {
        let actual = "test".ellipsis(maxLengthOfString: 10)

        XCTAssertEqual(actual, "test")
    }

    func test_ellipsis_givenStringEqualMaxLength_expectNoEllipsis() {
        let actual = "test".ellipsis(maxLengthOfString: 4)

        XCTAssertEqual(actual, "test")
    }

    func test_ellipsis_givenStringOverMaxLength_expectEllipsis_expectMaxLengthString() {
        let given = "1234567890"
        let maxLength = given.count - 1
        let actual = given.ellipsis(maxLengthOfString: maxLength)

        XCTAssertEqual(actual, "123456...")
        XCTAssertEqual(actual.count, maxLength)
    }
}
