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
        let actual = atomic.value

        XCTAssertNil(actual)
    }

    func test_givenCallSetWithNewValue_expectGetCallReceivesNewValue() {
        let expect = "new value"

        atomic.value = expect

        let actual = atomic.value

        XCTAssertEqual(expect, actual)
    }

    func test_givenSetAndGetDifferentThreads_expectGetNewlySetValue() {
        let expect = "new value"

        DispatchQueue.global(qos: .background).sync {
            atomic.value = expect
        }

        let actual = atomic.value

        XCTAssertEqual(expect, actual)
    }
}
