import Foundation
@testable import iOSBlanky
import XCTest

class StringsTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        TestUtil.tearDown()

        super.tearDown()
    }

    func test_allStringsLocalizationsDefined() {
        DI.shared.override(.bundle, value: bundle, forType: Bundle.self)

        for key in Strings.allCases {
            let value = key.localized
            XCTAssertNotNil(value)
            XCTAssertNotEqual(value, key.rawValue) // If key and value are equal, then the string was not defined in the localization file
        }
    }
}
