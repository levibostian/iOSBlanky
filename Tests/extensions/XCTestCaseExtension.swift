import Foundation
import XCTest

extension XCTestCase {
    func waitForExpectations(file: StaticString = #file, line: UInt = #line) {
        waitForExpectations(timeout: TestUtil.defaultWaitTimeout, handler: nil)
    }

    func XCTAssertBackgroundThread(file: StaticString = #file, line: UInt = #line) {
        if Thread.isMainThread {
            XCTFail("You're on the main thread. That's not what you wanted.")
        }
    }

    func XCTAssertMainThread(file: StaticString = #file, line: UInt = #line) {
        if !Thread.isMainThread {
            XCTFail("You're NOT on the main thread. That's not what you wanted.")
        }
    }

    var bundle: Bundle {
        Bundle(for: TestUtil.self)
    }
}
