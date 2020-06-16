import Foundation

protocol ThreadUtil {
    var isMain: Bool { get }
    var isBackground: Bool { get }

    func assertMain()
    func assertBackground()
}

// sourcery: InjectRegister = "ThreadUtil"
class AppThreadUtil: ThreadUtil {
    var isMain: Bool {
        Thread.isMainThread
    }

    var isBackground: Bool {
        !isMain
    }

    func assertMain() {
        if !isMain {
            fatalError("You are not on the UI thread")
        }
    }

    func assertBackground() {
        if !isBackground {
            fatalError("You are not on a background thread")
        }
    }
}
