import Foundation

class AtomicBool: ExpressibleByBooleanLiteral {
    fileprivate let atomic: Atomic<Bool> = {
        let atomic: Atomic<Bool> = Atomic()
        atomic.set(false)
        return atomic
    }()

    var value: Bool {
        get {
            atomic.get!
        }
        set {
            atomic.set(newValue)
        }
    }

    typealias BooleanLiteralType = Bool

    convenience init() {
        self.init(booleanLiteral: false)
    }

    required init(booleanLiteral value: Bool) {
        atomic.set(value)
    }
}
