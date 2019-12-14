import Foundation

class AtomicCounter {
    private let atomic = Atomic<Int>()

    init() {
        atomic.set(0)
    }

    var value: Int {
        return atomic.get!
    }

    func increment() -> Int {
        return atomic.set { (currentValue) -> Int? in
            currentValue! + 1
        }!
    }

    func decrement() -> Int {
        return atomic.set { (currentValue) -> Int? in
            if currentValue! == 0 {
                fatalError("You're trying to decrement a value that's already 0. Probably means you have a bug.")
            }

            return currentValue! - 1
        }!
    }
}
