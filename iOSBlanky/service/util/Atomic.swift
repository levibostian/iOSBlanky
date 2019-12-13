import Foundation

class Atomic<DataType: Any> {
    fileprivate let queue = DispatchQueue(label: "Atomic")

    fileprivate var value: DataType?

    var get: DataType? {
        return queue.sync { () -> DataType? in
            value
        }
    }

    func set(_ newValue: DataType?) {
        queue.sync {
            value = newValue
        }
    }

    func set(handler: (DataType?) -> DataType?) -> DataType? {
        return queue.sync {
            let currentValue = value
            let newValue = handler(currentValue)

            value = newValue

            return newValue
        }
    }
}
