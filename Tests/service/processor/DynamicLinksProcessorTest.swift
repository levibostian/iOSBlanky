@testable import App
import Foundation
import XCTest

class DynamicLinksProcessorTest: UnitTest {
    // MARK: getActionFromDynamicLink

    func test_getActionFromDynamicLink_givenPasswordlessTokenExchangeLink_expectGetAction() {
        let givenPasswordlessToken = "token-here-58473393"

        let givenLink = DynamicLinkFake.getFromQueryParams("token=\(givenPasswordlessToken)")

        let expected = givenPasswordlessToken

        let actual = DynamicLinksProcessor.getActionFromDynamicLink(URL(string: givenLink)!)

        XCTAssertNotNil(actual)

        guard case .tokenExchange(let actualToken) = actual else {
            return XCTFail("Expected action")
        }

        XCTAssertEqual(actualToken, expected)
    }

    func test_getActionFromDynamicLink_givenLinkWithNoAction_expectGetNil() {
        let givenLink = DynamicLinkFake.getFromQueryParams("random_query_no_action=123")

        let actual = DynamicLinksProcessor.getActionFromDynamicLink(URL(string: givenLink)!)

        XCTAssertNil(actual)
    }
}
