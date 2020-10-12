@testable import App
import Foundation
import RxSwift

/**
 This is a manually made mock. That's because it's super annoying to need to define a return value for the properties every time that you use the Rx schedulers mock. Making a manual mock that returns a default schedule is better.
 */
class RxSchedulersMock: RxSchedulers {
    var underlyingSchedulers: RxSchedulers = RxSwiftSchedulers()

    var uiCalled: Bool = false
    var uiCalledCount: Int = 0
    var ui: SchedulerType {
        uiCalled = true
        uiCalledCount += 1
        return underlyingSchedulers.ui
    }

    var backgroundCalled: Bool = false
    var backgroundCalledCount: Int = 0
    var background: SchedulerType {
        backgroundCalled = true
        backgroundCalledCount += 1
        return underlyingSchedulers.background
    }

    enum ThreadType {
        case ui
        case background
    }
}
