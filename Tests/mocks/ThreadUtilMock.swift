@testable import App
import Foundation

class ThreadUtilMock: ThreadUtil {
    private let enableAssertMain: Bool
    private let enableAssertBackground: Bool

    init(enableAssertMain: Bool = true, enableAssertBackground: Bool = true) {
        self.enableAssertMain = enableAssertMain
        self.enableAssertBackground = enableAssertBackground
    }

    var isMain: Bool {
        Thread.isMainThread
    }

    var isBackground: Bool {
        !isMain
    }

    func assertMain() {
        guard enableAssertMain else {
            return
        }

        if !isMain {
            fatalError("You are not on the UI thread")
        }
    }

    func assertBackground() {
        guard enableAssertBackground else {
            return
        }

        if !isBackground {
            fatalError("You are not on a background thread")
        }
    }
}
