@testable import App
import Foundation
import XCTest

class AtomicTests: UnitTest {
    private var atomic: Atomic<String>!

    override func setUp() {
        super.setUp()

        atomic = Atomic()
    }

    func test_init_expectNil() {
        let actual = atomic.get

        XCTAssertNil(actual)
    }

    func test_givenCallSetWithNewValue_expectGetCallReceivesNewValue() {
        let expect = "new value"

        atomic.set(expect)

        let actual = atomic.get

        XCTAssertEqual(expect, actual)
    }

    func test_givenSetAndGetDifferentThreads_expectGetNewlySetValue() {
        let expect = "new value"

        DispatchQueue.global(qos: .background).sync {
            atomic.set(expect)
        }

        let actual = atomic.get

        XCTAssertEqual(expect, actual)
    }

    func test_givenSetNewValueFromHandler_expectReceiveNewlySetValue() {
        let expect = "new value"

        let actual = atomic.set { (oldValue) -> String? in
            expect
        }

        XCTAssertEqual(expect, actual)
    }

    func test_setWithHandler_expectToGetOldValueInLambda() {
        let expectOldValue = "oldValue"

        atomic.set(expectOldValue)

        let actual = atomic.set { (actualOldValue) -> String? in
            XCTAssertEqual(expectOldValue, actualOldValue)

            return nil
        }

        XCTAssertNil(actual)
    }
}
