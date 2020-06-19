import Foundation

class AtomicBool: ExpressibleByBooleanLiteral {
    fileprivate let atomic: Atomic<Bool> = {
        let atomic: Atomic<Bool> = Atomic()
        atomic.value = false
        return atomic
    }()

    var value: Bool {
        get {
            atomic.value!
        }
        set {
            atomic.value = newValue
        }
    }

    typealias BooleanLiteralType = Bool

    convenience init() {
        self.init(booleanLiteral: false)
    }

    required init(booleanLiteral value: Bool) {
        atomic.value = value
    }
}
