import Foundation
@testable import iOSBlanky
import RxSwift
import XCTest

class FirebaseAnalyticsActivityLoggerTest: XCTestCase {
    func test_Util_makeEventNameAppropriate_expectReplaceSpaces() {
        let given = "Name of event"

        let actual = FirebaseAnalyticsActivityLogger.Util.makeEventNameAppropriate(given)

        XCTAssertEqual(actual, "Name_of_event")
    }

    func test_Util_makeEventNameAppropriate_expectReplaceSpecialChars() {
        let given = "Name:of|event?"

        let actual = FirebaseAnalyticsActivityLogger.Util.makeEventNameAppropriate(given)

        XCTAssertEqual(actual, "Name_of_event_")
    }

    func test_Util_makeEventNameAppropriate_expectAllowNumbers() {
        let given = "12345"

        let actual = FirebaseAnalyticsActivityLogger.Util.makeEventNameAppropriate(given)

        XCTAssertEqual(actual, "12345")
    }
}
