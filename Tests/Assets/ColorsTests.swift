@testable import App
import Foundation
import XCTest

class ColorsTests: UnitTest {
    func test_allColorsDefined() {
        for key in Colors.allCases {
            let value = key.color
            XCTAssertNotNil(value)
        }
    }
}
