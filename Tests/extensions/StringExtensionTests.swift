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
}
