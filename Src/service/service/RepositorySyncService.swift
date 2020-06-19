import Foundation
import RxSwift
import Teller

/**
 Object meant for repository syncing. Mainly used for background tasks.
 */
protocol RepositorySyncService: AutoMockable {
    func syncAll(onComplete: @escaping ([RefreshResult]) -> Void) // no forcing to refresh.
    func refreshRepos(onComplete: @escaping (RefreshResult) -> Void)
}

// sourcery: InjectRegister = "RepositorySyncService"
class TellerRepositorySyncService: RepositorySyncService {
    fileprivate let reposRepository: ReposTellerRepository
    fileprivate let keyValueStorage: KeyValueStorage
    fileprivate let logger: ActivityLogger

    fileprivate let disposeBag = DisposeBag()

    init(reposRepository: ReposTellerRepository, keyValueStorage: KeyValueStorage, logger: ActivityLogger) {
        self.reposRepository = reposRepository
        self.keyValueStorage = keyValueStorage
        self.logger = logger
    }

    func syncAll(onComplete: @escaping ([RefreshResult]) -> Void) {
        logger.breadcrumb("begin syncAll", extras: nil)

        refreshRepos { result in
            self.logger.breadcrumb("end syncAll", extras: nil)
            onComplete([result])
        }
    }

    func refreshRepos(onComplete: @escaping (RefreshResult) -> Void) {
        logger.breadcrumb("start repos sync", extras: nil)

        guard let username = keyValueStorage.string(forKey: .lastUsernameSearch) else {
            logger.breadcrumb("username has not been set. skipping", extras: nil)

            onComplete(RefreshResult.skipped(reason: .cancelled))
            return
        }

        reposRepository.requirements = ReposTellerRepository.DataSource.Requirements(githubUsername: username)

        try! reposRepository.refresh(force: false)
            .subscribe(onSuccess: { result in
                self.logger.breadcrumb("done repos sync for user", extras: [
                    "result": result.description
                ])
                onComplete(result)
            }).disposed(by: disposeBag)
    }
}
