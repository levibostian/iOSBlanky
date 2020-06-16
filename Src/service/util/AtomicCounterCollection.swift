import Foundation

class AtomicCounterCollection<DataType: Hashable> {
    fileprivate let atomic = Atomic<[DataType: Int]>()

    init() {
        clear()
    }

    func clear() {
        atomic.set([:])
    }

    func value(for data: DataType) -> Int {
        if let currentValue = atomic.get![data] {
            return currentValue
        }

        return 0
    }

    func increment(for data: DataType) -> Int {
        atomic.set { (currentCollection) -> [DataType: Int]? in
            let currentIncrementValue = currentCollection![data]
            var newValue = currentCollection!

            var newIncrementValue = 1
            if let currentIncrementValue = currentIncrementValue {
                newIncrementValue = currentIncrementValue + 1
            }

            newValue[data] = newIncrementValue

            return newValue
        }![data]!
    }

    func decrement(for data: DataType) -> Int {
        atomic.set { (currentCollection) -> [DataType: Int]? in
            let currentIncrementValue = currentCollection![data]
            var newValue = currentCollection!

            var newIncrementValue = 1
            if let currentIncrementValue = currentIncrementValue {
                newIncrementValue = currentIncrementValue - 1
            }

            newValue[data] = newIncrementValue

            return newValue
        }![data]!
    }
}
