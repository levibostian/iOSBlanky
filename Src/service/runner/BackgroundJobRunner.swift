import Foundation
import UIKit

protocol BackgroundJobRunner {
    func runPeriodicBackgroundJobs(onComplete: @escaping (UIBackgroundFetchResult) -> Void)
    func handleDataNotification(_ notification: DataNotification, onComplete: @escaping (UIBackgroundFetchResult) -> Void)
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
        logger.appEventOccurred(.performBackgroundSync, extras: [
            .type: "periodic"
        ])

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

    func handleDataNotification(_ notification: DataNotification, onComplete: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let notificationAction = NotificationUtil.getActionFrom(dataNotification: notification) else {
            onComplete(.noData)
            return
        }

        switch notificationAction {
        case .updateDrive:
            logger.appEventOccurred(.performBackgroundSync, extras: [
                .type: "push notification"
            ])

            syncRepos { result in
                onComplete(result)
            }
        }
    }

    fileprivate func syncRepos(onComplete: @escaping (UIBackgroundFetchResult) -> Void) {
        logger.breadcrumb("running sync programs background task", extras: nil)

        repositorySyncService.syncAll { refreshResults in
            let repositorySyncResult = UIBackgroundFetchResult.get(from: refreshResults)

            self.logger.breadcrumb("done running sync repos background task", extras: [
                "result": repositorySyncResult.name
            ])

            onComplete(repositorySyncResult)
        }
    }
}
