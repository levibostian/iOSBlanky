@testable import App
import Foundation
import XCTest

class StringReplaceUtilTest: UnitTest {
    private var stringReplaceUtil: StringReplaceUtil!

    override func setUp() {
        super.setUp()

        stringReplaceUtil = StringReplaceUtil(environment: DI.shared.inject(.environment))
    }

    func test_replace_givenAllTemplates_expectTemplateReplaced() {
        for template in StringReplaceTemplate.allCases {
            XCTAssertNotEqual(stringReplaceUtil.replace("\(template.rawValue)"), template.rawValue, "You did not replace template, \(template.rawValue), in StringReplaceUtil")
        }
    }

    func test_replace_givenValuesToReplaceWith_expectReplacementSuccessful() {
        let given = "Workouts for week {{week}}"
        let expected = "Workouts for week 10"

        let actual = stringReplaceUtil.replace(given, values: [
            "week": String(10)
        ])

        XCTAssertEqual(expected, actual)
    }
}
