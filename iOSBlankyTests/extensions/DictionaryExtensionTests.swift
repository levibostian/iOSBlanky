import Foundation
@testable import iOSBlanky
import XCTest

class DictionaryExtensionTests: XCTestCase {
    func test_toStringDictionary_givenAnyHashableDictionaryOnlyStringKeys_expectSameDictionary() {
        let given: [AnyHashable: Any] = ["foo": 1]

        let actual = given.toStringDictionary()

        XCTAssertEqual(actual.count, given.count)

        let actualValue: Int = actual["foo"] as! Int
        XCTAssertEqual(actualValue, 1)
    }

    func test_toStringDictionary_givenAnyHashableDictionaryNoStringKeys_expectEmptyDictionary() {
        let given: [AnyHashable: Any] = [CGFloat(exactly: 1): 1]

        let actual = given.toStringDictionary()

        XCTAssertTrue(actual.isEmpty)
    }
}
