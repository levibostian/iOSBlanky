import Foundation
import RxSwift
import Teller

/**
 Object meant for repository syncing. Mainly used for background tasks.
 */
protocol RepositorySyncService {
    func syncAll(onComplete: @escaping ([RefreshResult]) -> Void) // no forcing to refresh.
    // individual repository syncing
    func syncRepos(force: Bool, onComplete: @escaping (RefreshResult) -> Void)
}

// sourcery: InjectRegister = "RepositorySyncService"
class TellerRepositorySyncService: RepositorySyncService {
    fileprivate let reposRepository: ReposRepository
    fileprivate let logger: ActivityLogger

    fileprivate let disposeBag = DisposeBag()

    init(reposRepository: ReposRepository, logger: ActivityLogger) {
        self.reposRepository = reposRepository
        self.logger = logger
    }

    func syncAll(onComplete: @escaping ([RefreshResult]) -> Void) {
        var fetchResults: [RefreshResult] = []

        logger.breadcrumb("begin syncAll", extras: nil)

        syncRepos(force: false) { result in
            fetchResults.append(result)

            self.logger.breadcrumb("end syncAll", extras: nil)
            onComplete(fetchResults)
        }
    }

    // This is not the best example, as it's just syncing a random username, but it's here for example. We probably wouldn't need to sync this repo anyway.
    func syncRepos(force: Bool, onComplete: @escaping (RefreshResult) -> Void) {
        reposRepository.requirements = ReposDataSourceRequirements(githubUsername: "")

        logger.breadcrumb("start reposRepository sync", extras: nil)
        try! reposRepository.refresh(force: force)
            .subscribe(onSuccess: { result in
                self.logger.breadcrumb("done repos repository sync", extras: [
                    "result": result.description
                ])

                onComplete(result)
            }).disposed(by: disposeBag)
    }
}
