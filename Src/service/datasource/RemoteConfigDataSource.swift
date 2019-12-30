import Foundation
import RxSwift
import Teller

typealias RemoteConfigRepository = Repository<RemoteConfigDataSource>
// sourcery: InjectRegister = "RemoteConfigRepository"
// sourcery: InjectCustom
extension RemoteConfigRepository {}

extension DI {
    var remoteConfigRepository: RemoteConfigRepository {
        let repository: RemoteConfigRepository = Repository(dataSource: inject(.remoteConfigDataSource))
        repository.requirements = RemoteConfigDataSource.Requirements()
        return repository
    }
}

class RemoteConfigDataSourceRequirements: RepositoryRequirements {
    var tag: RepositoryRequirements.Tag {
        return "Remote config values"
    }
}

// sourcery: InjectRegister = "RemoteConfigDataSource"
class RemoteConfigDataSource: RepositoryDataSource {
    typealias Cache = Void
    typealias Requirements = RemoteConfigDataSourceRequirements
    typealias FetchResult = Void
    typealias FetchError = Error

    fileprivate let remoteConfigProvider: RemoteConfigProvider

    init(remoteConfigProvider: RemoteConfigProvider) {
        self.remoteConfigProvider = remoteConfigProvider
    }

    // 12 hours is the default time that Firebase remote config fetches new data.
    var maxAgeOfCache: Period = Period(unit: 12, component: .hour)

    func fetchFreshCache(requirements: RemoteConfigDataSourceRequirements) -> Single<FetchResponse<Void, FetchError>> {
        return Single.create { (observer) -> Disposable in
            self.remoteConfigProvider.fetch { result in
                observer(.success(result))
            }
            return Disposables.create()
        }
    }

    func saveCache(_ fetchedData: Void, requirements: RemoteConfigDataSourceRequirements) throws {}

    func observeCache(requirements: RemoteConfigDataSourceRequirements) -> Observable<Void> {
        return Observable.never()
    }

    func isCacheEmpty(_ cache: Void, requirements: RemoteConfigDataSourceRequirements) -> Bool {
        return false
    }
}
