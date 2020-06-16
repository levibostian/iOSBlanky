import Foundation
import RxSwift
import UIKit
import Wendy

protocol PendingTasks: AutoMockable {
    func addDownloadNewFilesPendingTask() -> Double
    func runAllTasks() -> UIBackgroundFetchResult
    func deleteAll()
    func runCollectionTasks(for collectionId: PendingTaskCollectionId) -> Single<RunCollectionTasksResult>
}

typealias RunCollectionTasksResult = PendingTasksRunnerResult

// sourcery: InjectRegister = "PendingTasks"
class WendyPendingTasks: PendingTasks {
    func addDownloadNewFilesPendingTask() -> Double {
        0
//         return Wendy.shared.addTask(DownloadDriveFilesPendingTask())
    }

    func runAllTasks() -> UIBackgroundFetchResult {
        Wendy.shared.performBackgroundFetch().backgroundFetchResult
    }

    func runCollectionTasks(for collectionId: PendingTaskCollectionId) -> Single<RunCollectionTasksResult> {
        Single.create { (observer) -> Disposable in
            Wendy.shared.runTasks(filter: RunAllTasksFilter.collection(id: collectionId.rawValue)) { result in
                observer(.success(result))
            }

            return Disposables.create()
        }
    }

    func deleteAll() {
        Wendy.shared.clear()
    }
}
