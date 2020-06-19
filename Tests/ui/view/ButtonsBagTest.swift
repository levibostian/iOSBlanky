@testable import App
import Foundation
import RxBlocking
import RxSwift
import XCTest

class ButtonsBagTest: UnitTest {
    private var buttonsBag: ButtonsBag<String>!

    override func setUp() {
        super.setUp()

        buttonsBag = ButtonsBag()
    }

    func test_getIdentifier_givenNotCalledCreate_expectNil() {
        let actual = buttonsBag.getIdentifier(for: UIButton())

        XCTAssertNil(actual)
    }

    func test_getIdentifier_givenCalledCreate_expectGetIdBack() {
        let givenIdentifier = "".random(length: 10)
        let button = buttonsBag.create(identifier: givenIdentifier)

        let expected = givenIdentifier
        let actual = buttonsBag.getIdentifier(for: button)

        XCTAssertEqual(actual, expected)
    }
}
