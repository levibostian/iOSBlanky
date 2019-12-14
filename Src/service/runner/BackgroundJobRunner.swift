import Foundation
import UIKit

protocol BackgroundJobRunner {
    func runPeriodicBackgroundJobs(onComplete: @escaping (UIBackgroundFetchResult) -> Void)
}

// sourcery: InjectRegister = "BackgroundJobRunner"
class AppBackgroundJobRunner: BackgroundJobRunner {
    fileprivate let logger: ActivityLogger
    fileprivate let pendingTasks: PendingTasks
    fileprivate let repositorySyncService: RepositorySyncService

    init(logger: ActivityLogger, pendingTasks: PendingTasks, repositorySyncService: RepositorySyncService) {
        self.logger = logger
        self.pendingTasks = pendingTasks
        self.repositorySyncService = repositorySyncService
    }

    func runPeriodicBackgroundJobs(onComplete: @escaping (UIBackgroundFetchResult) -> Void) {
        logger.breadcrumb("running background tasks", extras: nil)

        repositorySyncService.syncAll { refreshResults in
            let repositorySyncResult = UIBackgroundFetchResult.get(from: refreshResults)
            let backgroundPendingTasksResult = self.pendingTasks.runAllTasks()

            let combinedSyncResult = UIBackgroundFetchResult.singleResult(from: [repositorySyncResult, backgroundPendingTasksResult])

            self.logger.breadcrumb("done running background tasks", extras: [
                "combined_result": combinedSyncResult.name,
                "repository_sync_result": repositorySyncResult.name,
                "pending_tasks_sync_result": backgroundPendingTasksResult.name
            ])

            onComplete(combinedSyncResult)
        }
    }
}
