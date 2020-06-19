@testable import App
import Foundation
import XCTest

class SetExtensionTests: XCTestCase {
    // MARK: - insert

    func test_insert_givenDuplicateNewMembers_expectSetAddsOneMember() {
        let given = ["new", "new"]
        var set: Set<String> = []
        let expected: Set<String> = ["new"]

        let results = set.insert(given)
        let actual = set

        XCTAssertEqual(expected, actual)

        XCTAssertTrue(results[0].inserted)
        XCTAssertFalse(results[1].inserted)
    }
}
