// swiftlint:disable line_length
// swiftlint:disable variable_name
// swiftlint:disable force_cast

// File generated from Sourcery-DI project: https://github.com/levibostian/Sourcery-DI
// Template version 0.1.0

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

enum Dependency: CaseIterable {
    case activityLogger
    case backgroundJobRunner
    case environment
    case gitHubAPI
    case notificationCenterManager
    case reposViewModel
    case startupUtil
    case themeManager
    case threadUtil
    case coreDataManager
    case bundle
    case dataDestroyer
    case database
    case remoteConfigProvider
    case secureStorage
    case gitHubMoyaProvider
    case moyaResponseProcessor
    case eventBus
    case reposDataSource
    case reposRepository
    case repositoryDao
    case jsonAdapter
    case repositorySyncService
    case userCredsManager
    case userDefaults
    case keyValueStorage
    case userManager
    case pendingTasks
}

class DI {
    static var shared: DI = DI()
    private var overrides: [Dependency: Any] = [:]
    private init() {}

    /**
     Designed to be used only for testing purposes to override dependencies.
     */
    func override<Value: Any>(_ dep: Dependency, value: Value, forType type: Value.Type) {
        overrides[dep] = value
    }

    /**
     Reset overrides. Meant to be used in `tearDown()` of tests.
     */
    func resetOverrides() {
        overrides = [:]
    }

    /**
     Use this generic method of getting a dependency, if you wish.
     */
    func inject<T>(_ dep: Dependency) -> T {
        switch dep {
        case .activityLogger: return _activityLogger as! T
        case .backgroundJobRunner: return _backgroundJobRunner as! T
        case .environment: return _environment as! T
        case .gitHubAPI: return _gitHubAPI as! T
        case .notificationCenterManager: return _notificationCenterManager as! T
        case .reposViewModel: return _reposViewModel as! T
        case .startupUtil: return _startupUtil as! T
        case .themeManager: return _themeManager as! T
        case .threadUtil: return _threadUtil as! T
        case .coreDataManager: return _coreDataManager as! T
        case .bundle: return _bundle as! T
        case .dataDestroyer: return _dataDestroyer as! T
        case .database: return _database as! T
        case .remoteConfigProvider: return _remoteConfigProvider as! T
        case .secureStorage: return _secureStorage as! T
        case .gitHubMoyaProvider: return _gitHubMoyaProvider as! T
        case .moyaResponseProcessor: return _moyaResponseProcessor as! T
        case .eventBus: return _eventBus as! T
        case .reposDataSource: return _reposDataSource as! T
        case .reposRepository: return _reposRepository as! T
        case .repositoryDao: return _repositoryDao as! T
        case .jsonAdapter: return _jsonAdapter as! T
        case .repositorySyncService: return _repositorySyncService as! T
        case .userCredsManager: return _userCredsManager as! T
        case .userDefaults: return _userDefaults as! T
        case .keyValueStorage: return _keyValueStorage as! T
        case .userManager: return _userManager as! T
        case .pendingTasks: return _pendingTasks as! T
        }
    }

    /**
     Use the property accessors below to inject pre-typed dependencies.
     */

    // ActivityLogger
    private var _activityLogger: ActivityLogger {
        if let overridenDep = self.overrides[.activityLogger] {
            return overridenDep as! ActivityLogger
        }
        return activityLogger
    }

    var activityLogger: ActivityLogger {
        return AppActivityLogger(environment: _environment)
    }

    // BackgroundJobRunner
    private var _backgroundJobRunner: BackgroundJobRunner {
        if let overridenDep = self.overrides[.backgroundJobRunner] {
            return overridenDep as! BackgroundJobRunner
        }
        return backgroundJobRunner
    }

    var backgroundJobRunner: BackgroundJobRunner {
        return AppBackgroundJobRunner(logger: _activityLogger, pendingTasks: _pendingTasks, repositorySyncService: _repositorySyncService)
    }

    // Environment
    private var _environment: Environment {
        if let overridenDep = self.overrides[.environment] {
            return overridenDep as! Environment
        }
        return environment
    }

    var environment: Environment {
        return AppEnvironment()
    }

    // GitHubAPI
    private var _gitHubAPI: GitHubAPI {
        if let overridenDep = self.overrides[.gitHubAPI] {
            return overridenDep as! GitHubAPI
        }
        return gitHubAPI
    }

    var gitHubAPI: GitHubAPI {
        return AppGitHubApi(gitHubMoyaProvider: _gitHubMoyaProvider, jsonAdapter: _jsonAdapter, responseProcessor: _moyaResponseProcessor)
    }

    // NotificationCenterManager
    private var _notificationCenterManager: NotificationCenterManager {
        if let overridenDep = self.overrides[.notificationCenterManager] {
            return overridenDep as! NotificationCenterManager
        }
        return notificationCenterManager
    }

    var notificationCenterManager: NotificationCenterManager {
        return AppNotificationCenterManager()
    }

    // ReposViewModel
    private var _reposViewModel: ReposViewModel {
        if let overridenDep = self.overrides[.reposViewModel] {
            return overridenDep as! ReposViewModel
        }
        return reposViewModel
    }

    var reposViewModel: ReposViewModel {
        return AppReposViewModel(reposRepository: _reposRepository, keyValueStorage: _keyValueStorage)
    }

    // StartupUtil
    private var _startupUtil: StartupUtil {
        if let overridenDep = self.overrides[.startupUtil] {
            return overridenDep as! StartupUtil
        }
        return startupUtil
    }

    var startupUtil: StartupUtil {
        return AppStartupUtil(coreDataManager: _coreDataManager)
    }

    // ThemeManager
    private var _themeManager: ThemeManager {
        if let overridenDep = self.overrides[.themeManager] {
            return overridenDep as! ThemeManager
        }
        return themeManager
    }

    var themeManager: ThemeManager {
        return AppThemeManager(keyValueStorage: _keyValueStorage)
    }

    // ThreadUtil
    private var _threadUtil: ThreadUtil {
        if let overridenDep = self.overrides[.threadUtil] {
            return overridenDep as! ThreadUtil
        }
        return threadUtil
    }

    var threadUtil: ThreadUtil {
        return AppThreadUtil()
    }

    // CoreDataManager (singleton)
    private var _coreDataManager: CoreDataManager {
        if let overridenDep = self.overrides[.coreDataManager] {
            return overridenDep as! CoreDataManager
        }
        return coreDataManager
    }

    private let _coreDataManager_queue = DispatchQueue(label: "DI_get_coreDataManager_queue")
    private var _coreDataManager_shared: CoreDataManager?
    var coreDataManager: CoreDataManager {
        return _coreDataManager_queue.sync {
            if let overridenDep = self.overrides[.coreDataManager] {
                return overridenDep as! CoreDataManager
            }
            let res = _coreDataManager_shared ?? _get_coreDataManager()
            _coreDataManager_shared = res
            return res
        }
    }

    private func _get_coreDataManager() -> CoreDataManager {
        return CoreDataManager()
    }

    // Bundle (custom. property getter provided via extension)
    private var _bundle: Bundle {
        if let overridenDep = self.overrides[.bundle] {
            return overridenDep as! Bundle
        }
        return bundle
    }

    // DataDestroyer
    private var _dataDestroyer: DataDestroyer {
        if let overridenDep = self.overrides[.dataDestroyer] {
            return overridenDep as! DataDestroyer
        }
        return dataDestroyer
    }

    var dataDestroyer: DataDestroyer {
        return DataDestroyer(keyValueStorage: _keyValueStorage, database: _database, pendingTasks: _pendingTasks)
    }

    // Database
    private var _database: Database {
        if let overridenDep = self.overrides[.database] {
            return overridenDep as! Database
        }
        return database
    }

    var database: Database {
        return Database(coreDataManager: _coreDataManager)
    }

    // RemoteConfigProvider
    private var _remoteConfigProvider: RemoteConfigProvider {
        if let overridenDep = self.overrides[.remoteConfigProvider] {
            return overridenDep as! RemoteConfigProvider
        }
        return remoteConfigProvider
    }

    var remoteConfigProvider: RemoteConfigProvider {
        return FirebaseRemoteConfig(logger: _activityLogger)
    }

    // SecureStorage
    private var _secureStorage: SecureStorage {
        if let overridenDep = self.overrides[.secureStorage] {
            return overridenDep as! SecureStorage
        }
        return secureStorage
    }

    var secureStorage: SecureStorage {
        return KeychainAccessSecureStorage(userManager: _userManager)
    }

    // GitHubMoyaProvider (custom. property getter provided via extension)
    private var _gitHubMoyaProvider: GitHubMoyaProvider {
        if let overridenDep = self.overrides[.gitHubMoyaProvider] {
            return overridenDep as! GitHubMoyaProvider
        }
        return gitHubMoyaProvider
    }

    // MoyaResponseProcessor
    private var _moyaResponseProcessor: MoyaResponseProcessor {
        if let overridenDep = self.overrides[.moyaResponseProcessor] {
            return overridenDep as! MoyaResponseProcessor
        }
        return moyaResponseProcessor
    }

    var moyaResponseProcessor: MoyaResponseProcessor {
        return MoyaResponseProcessor(jsonAdapter: _jsonAdapter, activityLogger: _activityLogger, eventBus: _eventBus)
    }

    // EventBus
    private var _eventBus: EventBus {
        if let overridenDep = self.overrides[.eventBus] {
            return overridenDep as! EventBus
        }
        return eventBus
    }

    var eventBus: EventBus {
        return NotificationCenterEventBus(notificationCenter: _notificationCenterManager, activityLogger: _activityLogger)
    }

    // ReposDataSource
    private var _reposDataSource: ReposDataSource {
        if let overridenDep = self.overrides[.reposDataSource] {
            return overridenDep as! ReposDataSource
        }
        return reposDataSource
    }

    var reposDataSource: ReposDataSource {
        return ReposDataSource(githubApi: _gitHubAPI, db: _database)
    }

    // ReposRepository (custom. property getter provided via extension)
    private var _reposRepository: ReposRepository {
        if let overridenDep = self.overrides[.reposRepository] {
            return overridenDep as! ReposRepository
        }
        return reposRepository
    }

    // RepositoryDao
    private var _repositoryDao: RepositoryDao {
        if let overridenDep = self.overrides[.repositoryDao] {
            return overridenDep as! RepositoryDao
        }
        return repositoryDao
    }

    var repositoryDao: RepositoryDao {
        return RepositoryDao(coreDataManager: _coreDataManager)
    }

    // JsonAdapter
    private var _jsonAdapter: JsonAdapter {
        if let overridenDep = self.overrides[.jsonAdapter] {
            return overridenDep as! JsonAdapter
        }
        return jsonAdapter
    }

    var jsonAdapter: JsonAdapter {
        return SwiftJsonAdpter()
    }

    // RepositorySyncService
    private var _repositorySyncService: RepositorySyncService {
        if let overridenDep = self.overrides[.repositorySyncService] {
            return overridenDep as! RepositorySyncService
        }
        return repositorySyncService
    }

    var repositorySyncService: RepositorySyncService {
        return TellerRepositorySyncService(reposRepository: _reposRepository, logger: _activityLogger)
    }

    // UserCredsManager
    private var _userCredsManager: UserCredsManager {
        if let overridenDep = self.overrides[.userCredsManager] {
            return overridenDep as! UserCredsManager
        }
        return userCredsManager
    }

    var userCredsManager: UserCredsManager {
        return UserCredsManager(userManager: _userManager, secureStorage: _secureStorage)
    }

    // UserDefaults (custom. property getter provided via extension)
    private var _userDefaults: UserDefaults {
        if let overridenDep = self.overrides[.userDefaults] {
            return overridenDep as! UserDefaults
        }
        return userDefaults
    }

    // KeyValueStorage
    private var _keyValueStorage: KeyValueStorage {
        if let overridenDep = self.overrides[.keyValueStorage] {
            return overridenDep as! KeyValueStorage
        }
        return keyValueStorage
    }

    var keyValueStorage: KeyValueStorage {
        return UserDefaultsKeyValueStorage(userDefaults: _userDefaults)
    }

    // UserManager
    private var _userManager: UserManager {
        if let overridenDep = self.overrides[.userManager] {
            return overridenDep as! UserManager
        }
        return userManager
    }

    var userManager: UserManager {
        return UserManager(storage: _keyValueStorage)
    }

    // PendingTasks
    private var _pendingTasks: PendingTasks {
        if let overridenDep = self.overrides[.pendingTasks] {
            return overridenDep as! PendingTasks
        }
        return pendingTasks
    }

    var pendingTasks: PendingTasks {
        return WendyPendingTasks()
    }
}
