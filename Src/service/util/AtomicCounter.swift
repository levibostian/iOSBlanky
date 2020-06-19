import Foundation

/**
 Increment or decrement number in an atomic way.

 Note: Requests to decrement below 0 are ignored.
 */
class AtomicCounter {
    private let atomic = Atomic<Int>()

    init() {
        atomic.value = 0
    }

    var value: Int {
        atomic.value!
    }

    func increment() -> Int {
        let oldValue = atomic.value!
        let newValue = oldValue + 1
        atomic.value = newValue

        return newValue
    }

    func decrement() -> Int {
        let oldValue = atomic.value!
        guard oldValue > 0 else {
            return oldValue // ignore request to decrement below 0
        }

        let newValue = oldValue - 1

        atomic.value = newValue

        return newValue
    }
}
