import Foundation
@testable import iOSBlanky
import XCTest

class StringsTests: UnitTest {
    func test_allStringsLocalizationsDefined() {
        for key in Strings.allCases {
            let value = key.localized
            XCTAssertNotNil(value)
            XCTAssertNotEqual(value, key.rawValue) // If key and value are equal, then the string was not defined in the localization file
        }
    }
}
