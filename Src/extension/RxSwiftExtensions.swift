import Foundation
import RxSwift

extension CompositeDisposable {
    static func += (left: inout CompositeDisposable, right: Disposable) {
        _ = left.insert(right)
    }
}
