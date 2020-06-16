import Foundation
import RxSwift

extension CompositeDisposable {
    static func += (left: inout CompositeDisposable, right: Disposable) {
        _ = left.insert(right)
    }
}

// MARK: Teller specific helpers

extension Single where Element == [RefreshResult] {
    static func concat(_ syncs: [Single<RefreshResult>]) -> Single<[RefreshResult]> {
        Single<[RefreshResult]>.create { (observer) -> Disposable in
            var disposeBag = CompositeDisposable()

            func helper(_ syncs: [Single<RefreshResult>], results: [RefreshResult]) {
                var syncs = syncs
                var results = results

                if syncs.isEmpty {
                    observer(.success(results))
                } else {
                    disposeBag += syncs[0].subscribe(onSuccess: { result in
                        syncs.removeFirst()
                        results.append(result)
                        helper(syncs, results: results)
                    })
                }
            }

            helper(syncs, results: [])

            return Disposables.create {
                disposeBag.dispose()
            }
        }
    }
}
