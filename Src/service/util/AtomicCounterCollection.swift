import Foundation

enum AtomicCounterCollectionError: LocalizedError {
    case cannotDecrementBelowZero

    var errorDescription: String? {
        localizedDescription
    }

    var localizedDescription: String {
        switch self {
        case .cannotDecrementBelowZero: return "Cannot decrement below zero"
        }
    }
}

class AtomicCounterCollection<DataType: Hashable> {
    fileprivate let atomic = Atomic<[DataType: Int]>()

    init() {
        clear()
    }

    func clear() {
        atomic.value = [:]
    }

    func value(for data: DataType) -> Int {
        if let currentValue = atomic.value![data] {
            return currentValue
        }

        return 0
    }

    func increment(for data: DataType) -> Int {
        var collection = atomic.value!

        let newItemValue = (collection[data] ?? 0) + 1
        collection[data] = newItemValue
        atomic.value = collection

        return newItemValue
    }

    func decrement(for data: DataType) throws -> Int {
        var collection = atomic.value!

        let newItemValue = (collection[data] ?? 0) - 1
        guard newItemValue >= 0 else {
            throw AtomicCounterCollectionError.cannotDecrementBelowZero
        }

        collection[data] = newItemValue
        atomic.value = collection

        return newItemValue
    }
}
