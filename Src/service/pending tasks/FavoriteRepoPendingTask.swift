import Foundation
import Wendy

/**
 This is meant to be an example. Not actually be used. That's why some code might be commented out.
 */
class FavoriteRepoPendingTask: PendingTask {
    struct TaskData: Codable {
        let repoId: Int
        let favorite: Bool
    }

    static var tag = "Favorite repo"

    private let api: GitHubAPI = DI.shared.inject(.gitHubAPI)
    private let logger: ActivityLogger = DI.shared.inject(.activityLogger)
    private let jsonAdapter: JsonAdapter = DI.shared.inject(.jsonAdapter)
    private let userManager: UserManager = DI.shared.inject(.userManager)

    private let disposeBag = DisposeBag()

    convenience init(taskData: TaskData) {
        self.init()

        self.dataId = try! jsonAdapter.toJson(taskData).string!
    }

    var taskId: Double?
    var dataId: String?
    var groupId: String?
    var manuallyRun: Bool = false
    var createdAt: Date?

    func isReadyToRun() -> Bool {
        userManager.isLoggedIn
    }

    func runTask(complete: @escaping (Error?) -> Void) {
        let data: TaskData = try! jsonAdapter.fromJson(dataId!.data!)

        logger.breadcrumb("Favoriting/unfavoriting repo pending task running", extras: [
            "data": data
        ])

//        api.favoriteRepo(repoId: data.repoId, favorite: data.favorite)
//            .subscribe(onSuccess: { result in
//                var pendingTaskError: Error?
//
//                switch result {
//                case .success:
//                    pendingTaskError = nil
//                case .failure(let error):
//                    if error.underlyingError is UserEnteredBadDataError {
//                        pendingTaskError = nil // If user entered bad data, repo does not exist. We ignore when that happens.
//                    } else {
//                        pendingTaskError = error
//                    }
//                }
//
//                self.logger.breadcrumb("Done favoriting/unfavoriting repo pending task", extras: [
//                    "data": data,
//                    "error": pendingTaskError ?? "(none)"
//                ])
//
//                complete(pendingTaskError)
//                return
//            }).disposed(by: disposeBag)
    }
}
