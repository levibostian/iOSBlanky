import Foundation

/**
 Guarantee the wrapped value is only ever accessed from one thread at a time.

 Inspired from: https://github.com/RougeWare/Swift-Atomic/blob/master/Sources/Atomic/Atomic.swift
 */
class Atomic<DataType: Any> {
    fileprivate let exclusiveAccessQueue = DispatchQueue.newUniqueQueue(label: "Atomic")

    fileprivate var unsafeValue: DataType?

    /**
     If you want to edit this value, you need to get the value, manipulate it, then set it. You do not get a handler. That is unsafe.
     */
    var value: DataType? {
        get { exclusiveAccessQueue.sync { unsafeValue } }
        set { exclusiveAccessQueue.sync { unsafeValue = newValue } }
    }
}
