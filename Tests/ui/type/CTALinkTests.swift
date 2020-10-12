@testable import App
import Foundation
import XCTest

class CTALinkTests: UnitTest {
    func test_type_givenUrl_expectUrlType() {
        let expectedUrl = URL.fake.random
        let ctaLink = CTALink(title: "title", url: expectedUrl)

        switch ctaLink.type {
        case .url(let actualUrl):
            XCTAssertEqual(expectedUrl, actualUrl)
        case .action:
            XCTFail()
        }
    }

    func test_type_givenAction_expectActionType() {
        let expectedAction = "action"
        let ctaLink = CTALink(title: "title", action: expectedAction)

        switch ctaLink.type {
        case .url:
            XCTFail()
        case .action(let actualAction):
            XCTAssertEqual(expectedAction, actualAction)
        }
    }
}
