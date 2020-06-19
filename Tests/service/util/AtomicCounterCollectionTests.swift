@testable import App
import Foundation
import XCTest

class AtomicCounterCollectionTests: UnitTest {
    private var atomicCounter: AtomicCounterCollection<String>!

    override func setUp() {
        super.setUp()

        atomicCounter = AtomicCounterCollection()
    }

    func test_init_expectZero() {
        let expected = 0
        let actual = atomicCounter.value(for: "key")

        XCTAssertEqual(expected, actual)
    }

    func test_increment_givenCalledOnceForKeyButNotAnotherKey_expect1() {
        let expected = 1

        let actual = atomicCounter.increment(for: "key")

        XCTAssertEqual(expected, actual)

        let otherActual = atomicCounter.value(for: "otherKey")

        XCTAssertEqual(otherActual, 0)
    }

    func test_increment_givenCalledOnce_expect1() {
        let expected = 1

        let actual = atomicCounter.increment(for: "key")

        XCTAssertEqual(expected, actual)
    }

    func test_increment_givenCalledManyTimes_expectTotal() {
        let expected = 5
        let key = "key"

        (0..<expected).forEach { _ in
            _ = atomicCounter.increment(for: key)
        }

        let actual = atomicCounter.value(for: key)

        XCTAssertEqual(expected, actual)
    }

    func test_increment_givenCalledOnDifferentThreads_expectTotal() {
        let expected = 4
        let key = "key"

        DispatchQueue.global(qos: .background).sync {
            _ = atomicCounter.increment(for: key)
            _ = atomicCounter.increment(for: key)
        }

        _ = atomicCounter.increment(for: key)
        _ = atomicCounter.increment(for: key)

        let actual = atomicCounter.value(for: key)

        XCTAssertEqual(expected, actual)
    }

    func test_decrement_givenCalledOnceAfterIncrement_expect0() {
        let expected = 0
        let key = "key"

        _ = atomicCounter.increment(for: key)
        let actual = atomicCounter.decrement(for: key)

        XCTAssertEqual(expected, actual)
    }

    func test_decrement_givenCalledManyTimes_expectTotal() {
        let expected = 5
        let key = "key"

        (0..<expected).forEach { _ in
            _ = atomicCounter.increment(for: key)
        }

        (0..<expected).forEach { _ in
            _ = atomicCounter.decrement(for: key)
        }

        let actual = atomicCounter.value(for: key)

        XCTAssertEqual(actual, 0)
    }

    func test_decrement_givenCalledOnDifferentThreads_expectTotal() {
        let key = "key"

        DispatchQueue.global(qos: .background).sync {
            _ = atomicCounter.increment(for: key)
            _ = atomicCounter.increment(for: key)
            _ = atomicCounter.increment(for: key)

            _ = atomicCounter.decrement(for: key)
        }

        _ = atomicCounter.decrement(for: key)
        _ = atomicCounter.increment(for: key)
        _ = atomicCounter.decrement(for: key)

        let actual = atomicCounter.value(for: key)

        XCTAssertEqual(actual, 1)
    }

    func test_clear_givenInit_expectNoEffect() {
        atomicCounter.clear()

        let actual = atomicCounter.value(for: "key")

        XCTAssertEqual(actual, 0)
    }

    func test_clear_givenIncrementMultipleValues_expectClearAllValues() {
        let key1 = "key1"
        let key2 = "key2"

        DispatchQueue.global(qos: .background).sync {
            _ = atomicCounter.increment(for: key1)
            _ = atomicCounter.increment(for: key1)
            _ = atomicCounter.increment(for: key2)

            _ = atomicCounter.increment(for: key1)
        }

        let actualValueKey1BeforeClear = atomicCounter.value(for: key1)
        let actualValueKey2BeforeClear = atomicCounter.value(for: key2)

        XCTAssertGreaterThan(actualValueKey1BeforeClear, 0)
        XCTAssertGreaterThan(actualValueKey2BeforeClear, 0)

        atomicCounter.clear()

        let actualValueKey1AfterClear = atomicCounter.value(for: key1)
        let actualValueKey2AfterClear = atomicCounter.value(for: key2)

        XCTAssertEqual(actualValueKey1AfterClear, 0)
        XCTAssertEqual(actualValueKey2AfterClear, 0)
    }
}
