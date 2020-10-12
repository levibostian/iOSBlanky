@testable import App
import Foundation
import XCTest

class AtomicCounterTests: UnitTest {
    private var atomicCounter: AtomicCounter!

    override func setUp() {
        super.setUp()

        atomicCounter = AtomicCounter()
    }

    func test_init_expectZero() {
        let expected = 0
        let actual = atomicCounter.value

        XCTAssertEqual(expected, actual)
    }

    func test_increment_givenCalledOnce_expect1() {
        let expected = 1

        let actual = atomicCounter.increment()

        XCTAssertEqual(expected, actual)
    }

    func test_increment_givenCalledManyTimes_expectTotal() {
        let expected = 5

        (0 ..< expected).forEach { _ in
            _ = atomicCounter.increment()
        }

        let actual = atomicCounter.value

        XCTAssertEqual(expected, actual)
    }

    func test_increment_givenCalledOnDifferentThreads_expectTotal() {
        let expected = 4

        DispatchQueue.global(qos: .background).sync {
            _ = atomicCounter.increment()
            _ = atomicCounter.increment()
        }

        _ = atomicCounter.increment()
        _ = atomicCounter.increment()

        let actual = atomicCounter.value

        XCTAssertEqual(expected, actual)
    }

    func test_decrement_givenCalledOnceAfterIncrement_expect0() {
        let expected = 0

        _ = atomicCounter.increment()
        let actual = atomicCounter.decrement()

        XCTAssertEqual(expected, actual)
    }

    func test_decrement_givenCalledManyTimes_expectTotal() {
        let expected = 5

        (0 ..< expected).forEach { _ in
            _ = atomicCounter.increment()
        }

        (0 ..< expected).forEach { _ in
            _ = atomicCounter.decrement()
        }

        let actual = atomicCounter.value

        XCTAssertEqual(actual, 0)
    }

    func test_decrement_givenCalledOnDifferentThreads_expectTotal() {
        DispatchQueue.global(qos: .background).sync {
            _ = atomicCounter.increment()
            _ = atomicCounter.increment()
            _ = atomicCounter.increment()

            _ = atomicCounter.decrement()
        }

        _ = atomicCounter.decrement()
        _ = atomicCounter.increment()
        _ = atomicCounter.decrement()

        let actual = atomicCounter.value

        XCTAssertEqual(actual, 1)
    }
}
