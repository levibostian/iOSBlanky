import Foundation
import Moya
import Swinject

class Di: ConvenientInject { // swiftlint:disable:this type_name
    static var inject: Di = Di()

    private let container = DiContainer()

    private init() {}

    var activityLogger: ActivityLogger {
        return container.inject(.activityLogger)
    }

    var reposViewModel: ReposViewModel {
        return container.inject(.reposViewModel)
    }

    var remoteConfig: RemoteConfigProvider {
        return container.inject(.remoteConfig)
    }

    var userManager: UserManager {
        return container.inject(.userManager)
    }

    var repositorySyncService: RepositorySyncService {
        return container.inject(.repositorySyncService)
    }
}

// Exists for when using `Di.inject.______` mostly in UI related classes when there is not a constructor to provide dependencies for.
protocol ConvenientInject {
    var activityLogger: ActivityLogger { get }
    var reposViewModel: ReposViewModel { get }
    var remoteConfig: RemoteConfigProvider { get }
    var userManager: UserManager { get }
    var repositorySyncService: RepositorySyncService { get }
}

class DiContainer {
    private let container: Container = Container()

    init() {
        registerDependencies()
    }

    private func registerDependencies() {
        container.register(ActivityLogger.self) { _ in AppActivityLogger() }
        container.register(CoreDataManager.self) { _ in CoreDataManager() }.singleton()
        container.register(RepositoryDao.self) { container in
            RepositoryDao(coreDataManager: self.inject(.coreDataManager, container))
        }
        container.register(ReposDataSource.self) { container in
            ReposDataSource(githubApi: self.inject(.githubApi, container),
                            db: self.inject(.database, container))
        }
        container.register(ReposRepository.self) { container in
            ReposRepository(dataSource: self.inject(.reposDataSource, container))
        }
        container.register(ReposViewModel.self) { container in
            ReposViewModel(reposRepository: self.inject(.reposRepository, container),
                           githubUsernameRepository: self.inject(.githubUsernameRepository, container))
        }
        container.register(GitHubUsernameRepository.self) { container in
            GitHubUsernameRepository(dataSource: self.inject(.githubDataSource, container))
        }
        container.register(GitHubUsernameDataSource.self) { _ in
            GitHubUsernameDataSource()
        }
        container.register(MoyaInstance.self) { container in
            let productionPlugins: [PluginType] = [
                MoyaAppendHeadersPlugin(userCredsManager: self.inject(.userCredsManager, container)),
                HttpLoggerMoyaPlugin()
            ]

            var plugins: [PluginType] = []
            plugins.append(contentsOf: productionPlugins)

            let networkActivityPlugin: NetworkActivityPlugin = NetworkActivityPlugin(networkActivityClosure: { change, _ in
                switch change {
                case .began:
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    }
                case .ended:
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            })

            plugins.append(networkActivityPlugin)

            return MoyaProvider<MultiTarget>(plugins: plugins)
        }
        container.register(GitHubAPI.self) { container in
            AppGitHubApi(moyaProvider: self.inject(.moyaProvider, container),
                         jsonAdapter: self.inject(.jsonAdapter, container),
                         responseProcessor: self.inject(.moyaResponseProcessor, container))
        }
        container.register(JsonAdapter.self) { _ in
            SwiftJsonAdpter()
        }
        container.register(Database.self) { container in
            Database(repositoryDao: self.inject(.repositoryDao, container))
        }
        container.register(EventBus.self) { _ in
            NotificationCenterEventBus()
        }
        container.register(MoyaResponseProcessor.self) { container in
            MoyaResponseProcessor(jsonAdapter: self.inject(.jsonAdapter, container),
                                  activityLogger: self.inject(.activityLogger, container),
                                  eventBus: self.inject(.eventBus, container))
        }
        container.register(RemoteConfigProvider.self) { _ in
            FirebaseRemoteConfig()
        }
        container.register(UserManager.self) { container in
            UserManager(storage: self.inject(.keyValueStorage, container))
        }
        container.register(UserCredsManager.self) { container in
            UserCredsManager(userManager: self.inject(.userManager, container),
                             secureStorage: self.inject(.secureStorage, container))
        }
        container.register(KeyValueStorage.self) { _ in
            UserDefaultsKeyValueStorage(userDefaults: UserDefaults.standard)
        }
        container.register(SecureStorage.self) { container in
            KeychainAccessSecureStorage(userManager: self.inject(.userManager, container))
        }
        container.register(RepositorySyncService.self) { container in
            TellerRepositorySyncService(reposRepository: self.inject(.reposRepository, container),
                                        githubUsernameRepository: self.inject(.githubUsernameRepository, container))
        }
    }

    func inject<T>(_ dep: Dependency) -> T {
        return inject(dep, container)
    }

    fileprivate func inject<T>(_ dep: Dependency, _ resolver: Resolver) -> T {
        return resolve(dep, resolver) as! T // swiftlint:disable:this force_cast
    }

    private func resolve(_ dep: Dependency, _ resolver: Resolver) -> Any {
        switch dep {
        case .activityLogger: return resolver.resolve(ActivityLogger.self)! as Any
        case .coreDataManager: return resolver.resolve(CoreDataManager.self)! as Any
        case .repositoryDao: return resolver.resolve(RepositoryDao.self)! as Any
        case .reposDataSource: return resolver.resolve(ReposDataSource.self)! as Any
        case .reposRepository: return resolver.resolve(ReposRepository.self)! as Any
        case .reposViewModel: return resolver.resolve(ReposViewModel.self)! as Any
        case .githubUsernameRepository: return resolver.resolve(GitHubUsernameRepository.self)! as Any
        case .githubDataSource: return resolver.resolve(GitHubUsernameDataSource.self)! as Any
        case .moyaProvider: return resolver.resolve(MoyaInstance.self)! as Any
        case .githubApi: return resolver.resolve(GitHubAPI.self)! as Any
        case .jsonAdapter: return resolver.resolve(JsonAdapter.self)! as Any
        case .database: return resolver.resolve(Database.self)! as Any
        case .eventBus: return resolver.resolve(EventBus.self)! as Any
        case .moyaResponseProcessor: return resolver.resolve(MoyaResponseProcessor.self)! as Any
        case .remoteConfig: return resolver.resolve(RemoteConfigProvider.self)! as Any
        case .userManager: return resolver.resolve(UserManager.self)! as Any
        case .userCredsManager: return resolver.resolve(UserCredsManager.self)! as Any
        case .keyValueStorage: return resolver.resolve(KeyValueStorage.self)! as Any
        case .secureStorage: return resolver.resolve(SecureStorage.self)! as Any
        case .repositorySyncService: return resolver.resolve(RepositorySyncService.self)! as Any
        }
    }
}
