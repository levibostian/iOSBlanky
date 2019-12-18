import Foundation
import RxSwift
import Teller

/**
 Object meant for repository syncing. Mainly used for background tasks.
 */
protocol RepositorySyncService: AutoMockable {
    func syncAll(onComplete: @escaping ([RefreshResult]) -> Void) // no forcing to refresh.
}

// sourcery: InjectRegister = "RepositorySyncService"
class TellerRepositorySyncService: RepositorySyncService {
    fileprivate let remoteConfigRepository: RemoteConfigRepository
    fileprivate let logger: ActivityLogger

    fileprivate let disposeBag = DisposeBag()

    init(remoteConfigRepository: RemoteConfigRepository, logger: ActivityLogger) {
        self.remoteConfigRepository = remoteConfigRepository
        self.logger = logger
    }

    func syncAll(onComplete: @escaping ([RefreshResult]) -> Void) {
        logger.breadcrumb("begin syncAll", extras: nil)

        syncRepos(force: false) { result in
            self.logger.breadcrumb("end syncAll", extras: nil)
            onComplete(result)
        }
    }

    func syncRepos(force: Bool, onComplete: @escaping ([RefreshResult]) -> Void) {
        logger.breadcrumb("start reposRepository sync", extras: nil)

        Single.concat([
            try! remoteConfigRepository.refresh(force: force)
        ]).subscribe(onSuccess: { result in
            self.logger.breadcrumb("done repos repository sync", extras: [
                "result": result.description
            ])
            onComplete(result)
        }).disposed(by: disposeBag)
    }
}
