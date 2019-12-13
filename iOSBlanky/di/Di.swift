import Foundation
import Moya
import Swinject
import Teller

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

    var startupUtil: StartupUtil {
        return container.inject(.startupUtil)
    }

    var themeManager: ThemeManager {
        return container.inject(.themeManager)
    }

    var environment: Environment {
        return container.inject(.environment)
    }

    var backgroundJobRunner: BackgroundJobRunner {
        return container.inject(.backgroundJobRunner)
    }

    var eventBus: EventBus {
        return container.inject(.eventBus)
    }
}

// Exists for when using `Di.inject.______` mostly in UI related classes when there is not a constructor to provide dependencies for.
protocol ConvenientInject {
    var activityLogger: ActivityLogger { get }
    var reposViewModel: ReposViewModel { get }
    var remoteConfig: RemoteConfigProvider { get }
    var userManager: UserManager { get }
    var repositorySyncService: RepositorySyncService { get }
    var startupUtil: StartupUtil { get }
    var themeManager: ThemeManager { get }
    var environment: Environment { get }
    var backgroundJobRunner: BackgroundJobRunner { get }
    var eventBus: EventBus { get }
}

class DiContainer {
    private let container: Container = Container()

    init() {
        registerDependencies()
    }

    private func registerDependencies() {
        container.register(ActivityLogger.self) { container in
            AppActivityLogger(environment: self.inject(.environment, container))
        }
        container.register(CoreDataManager.self) { container in
            CoreDataManager(threadUtil: self.inject(.threadUtil, container))
        }.singleton()
        container.register(RepositoryDao.self) { container in
            RepositoryDao(coreDataManager: self.inject(.coreDataManager, container))
        }
        container.register(ReposDataSource.self) { container in
            ReposDataSource(githubApi: self.inject(.githubApi, container),
                            db: self.inject(.database, container))
        }
        container.register(ReposRepository.self) { container in
            Repository(dataSource: self.inject(.reposDataSource, container))
        }
        container.register(ReposViewModel.self) { container in
            ReposViewModel(reposRepository: self.inject(.reposRepository, container),
                           keyValueStorage: self.inject(.keyValueStorage, container))
        }
        container.register(MoyaInstance.self) { container in
            let productionPlugins: [PluginType] = [
                MoyaAppendHeadersPlugin(userCredsManager: self.inject(.userCredsManager, container)),
                HttpLoggerMoyaPlugin(logger: self.inject(.activityLogger, container))
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
        container.register(EventBus.self) { container in
            NotificationCenterEventBus(notificationCenter: self.inject(.notificationCenterManager, container),
                                       activityLogger: self.inject(.activityLogger, container))
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
                                        logger: self.inject(.activityLogger, container))
        }
        container.register(ThreadUtil.self) { _ in
            AppThreadUtil()
        }
        container.register(StartupUtil.self) { container in
            AppStartupUtil(coreDataManager: self.inject(.coreDataManager, container))
        }
        container.register(FileStorage.self) { _ in
            FileMangerFileStorage()
        }
        container.register(ThemeManager.self) { container in
            AppThemeManager(keyValueStorage: self.inject(.keyValueStorage, container))
        }
        container.register(Environment.self) { _ in
            AppEnvironment()
        }
        container.register(BackgroundJobRunner.self) { container in
            AppBackgroundJobRunner(logger: self.inject(.activityLogger, container),
                                   pendingTasks: self.inject(.pendingTasks, container),
                                   repositorySyncService: self.inject(.repositorySyncService, container))
        }
        container.register(PendingTasks.self) { _ in
            WendyPendingTasks()
        }
        container.register(NotificationCenterManager.self) { _ in
            AppNotificationCenterManager()
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
        case .threadUtil: return resolver.resolve(ThreadUtil.self)! as Any
        case .startupUtil: return resolver.resolve(StartupUtil.self)! as Any
        case .fileStorage: return resolver.resolve(FileStorage.self)! as Any
        case .themeManager: return resolver.resolve(ThemeManager.self)! as Any
        case .environment: return resolver.resolve(Environment.self)! as Any
        case .backgroundJobRunner: return resolver.resolve(BackgroundJobRunner.self)! as Any
        case .pendingTasks: return resolver.resolve(PendingTasks.self)! as Any
        case .notificationCenterManager: return resolver.resolve(NotificationCenterManager.self)! as Any
        }
    }
}
