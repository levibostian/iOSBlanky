import Foundation
import XCTest

extension XCTestCase {
    func waitForExpectations(file _: StaticString = #file, line _: UInt = #line) {
        waitForExpectations(timeout: TestUtil.defaultWaitTimeout, handler: nil)
    }

    func waitForExpectations(for expectations: [XCTestExpectation], enforceOrder: Bool = false, file _: StaticString = #file, line _: UInt = #line) {
        wait(for: expectations, timeout: TestUtil.defaultWaitTimeout, enforceOrder: enforceOrder)
    }

    func XCTAssertBackgroundThread(file _: StaticString = #file, line _: UInt = #line) {
        if Thread.isMainThread {
            XCTFail("You're on the main thread. That's not what you wanted.")
        }
    }

    func XCTAssertMainThread(file _: StaticString = #file, line _: UInt = #line) {
        if !Thread.isMainThread {
            XCTFail("You're NOT on the main thread. That's not what you wanted.")
        }
    }

    var bundle: Bundle {
        Bundle(for: TestUtil.self)
    }
}

extension UIButton {
    func assertActionSet(forTarget target: Any) {
        let numberOfActions = actions(forTarget: target, forControlEvent: .touchUpInside)?.count ?? 0
        XCTAssertGreaterThan(numberOfActions, 0)
    }
}
