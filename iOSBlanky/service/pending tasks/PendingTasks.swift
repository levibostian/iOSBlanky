import Foundation
import UIKit
import Wendy

protocol PendingTasks: AutoMockable {
    func addDownloadDriveFilesPendingTask() -> Double
    func runAllTasks() -> UIBackgroundFetchResult
}

class WendyPendingTasks: PendingTasks {
    func addDownloadDriveFilesPendingTask() -> Double {
        return 0
//         return Wendy.shared.addTask(DownloadDriveFilesPendingTask())
    }

    func runAllTasks() -> UIBackgroundFetchResult {
        return Wendy.shared.performBackgroundFetch().backgroundFetchResult
    }
}
