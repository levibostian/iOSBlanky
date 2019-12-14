import Foundation
import UIKit
import Wendy

protocol PendingTasks: AutoMockable {
    func addDownloadNewFilesPendingTask() -> Double
    func runAllTasks() -> UIBackgroundFetchResult
}

// sourcery: InjectRegister = "PendingTasks"
class WendyPendingTasks: PendingTasks {
    func addDownloadNewFilesPendingTask() -> Double {
        return 0
//         return Wendy.shared.addTask(DownloadDriveFilesPendingTask())
    }

    func runAllTasks() -> UIBackgroundFetchResult {
        return Wendy.shared.performBackgroundFetch().backgroundFetchResult
    }
}
