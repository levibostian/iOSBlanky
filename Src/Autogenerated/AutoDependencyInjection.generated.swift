// swiftlint:disable line_length
// swiftlint:disable variable_name
// swiftlint:disable force_cast

// File generated from Sourcery-DI project: https://github.com/levibostian/Sourcery-DI
// Template version 0.1.1

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
    case loginViewModel
    case notificationCenterManager
    case reposRepository
    case reposViewModel
    case startupUtil
    case themeManager
    case threadUtil
    case userManager
    case userRepository
    case bundle
    case coreDataManager
    case remoteConfigAdapter
    case dataDestroyer
    case database
    case fileStorage
    case gitHubRequestRunner
    case secureStorage
    case gitHubMoyaProvider
    case moyaResponseProcessor
    case eventBus
    case reposDataSource
    case repositoryDao
    case stringReplaceUtil
    case jsonAdapter
    case reposTellerRepository
    case repositorySyncService
    case userDefaults
    case keyValueStorage
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
        case .loginViewModel: return _loginViewModel as! T
        case .notificationCenterManager: return _notificationCenterManager as! T
        case .reposRepository: return _reposRepository as! T
        case .reposViewModel: return _reposViewModel as! T
        case .startupUtil: return _startupUtil as! T
        case .themeManager: return _themeManager as! T
        case .threadUtil: return _threadUtil as! T
        case .userManager: return _userManager as! T
        case .userRepository: return _userRepository as! T
        case .bundle: return _bundle as! T
        case .coreDataManager: return _coreDataManager as! T
        case .remoteConfigAdapter: return _remoteConfigAdapter as! T
        case .dataDestroyer: return _dataDestroyer as! T
        case .database: return _database as! T
        case .fileStorage: return _fileStorage as! T
        case .gitHubRequestRunner: return _gitHubRequestRunner as! T
        case .secureStorage: return _secureStorage as! T
        case .gitHubMoyaProvider: return _gitHubMoyaProvider as! T
        case .moyaResponseProcessor: return _moyaResponseProcessor as! T
        case .eventBus: return _eventBus as! T
        case .reposDataSource: return _reposDataSource as! T
        case .repositoryDao: return _repositoryDao as! T
        case .stringReplaceUtil: return _stringReplaceUtil as! T
        case .jsonAdapter: return _jsonAdapter as! T
        case .reposTellerRepository: return _reposTellerRepository as! T
        case .repositorySyncService: return _repositorySyncService as! T
        case .userDefaults: return _userDefaults as! T
        case .keyValueStorage: return _keyValueStorage as! T
        case .pendingTasks: return _pendingTasks as! T
        }
    }

    /**
     Use the property accessors below to inject pre-typed dependencies.
     */

    // ActivityLogger
    private var _activityLogger: ActivityLogger {
        if let overridenDep = overrides[.activityLogger] {
            return overridenDep as! ActivityLogger
        }
        return activityLogger
    }

    var activityLogger: ActivityLogger {
        AppActivityLogger(environment: _environment)
    }

    // BackgroundJobRunner
    private var _backgroundJobRunner: BackgroundJobRunner {
        if let overridenDep = overrides[.backgroundJobRunner] {
            return overridenDep as! BackgroundJobRunner
        }
        return backgroundJobRunner
    }

    var backgroundJobRunner: BackgroundJobRunner {
        AppBackgroundJobRunner(logger: _activityLogger, pendingTasks: _pendingTasks, repositorySyncService: _repositorySyncService)
    }

    // Environment
    private var _environment: Environment {
        if let overridenDep = overrides[.environment] {
            return overridenDep as! Environment
        }
        return environment
    }

    var environment: Environment {
        AppEnvironment(bundle: _bundle)
    }

    // GitHubAPI
    private var _gitHubAPI: GitHubAPI {
        if let overridenDep = overrides[.gitHubAPI] {
            return overridenDep as! GitHubAPI
        }
        return gitHubAPI
    }

    var gitHubAPI: GitHubAPI {
        AppGitHubApi(requestRunner: _gitHubRequestRunner, jsonAdapter: _jsonAdapter, activityLogger: _activityLogger, eventBus: _eventBus)
    }

    // LoginViewModel
    private var _loginViewModel: LoginViewModel {
        if let overridenDep = overrides[.loginViewModel] {
            return overridenDep as! LoginViewModel
        }
        return loginViewModel
    }

    var loginViewModel: LoginViewModel {
        AppLoginViewModel(userManager: _userManager, dataDestroyer: _dataDestroyer, userRepository: _userRepository, bundle: _bundle, logger: _activityLogger)
    }

    // NotificationCenterManager
    private var _notificationCenterManager: NotificationCenterManager {
        if let overridenDep = overrides[.notificationCenterManager] {
            return overridenDep as! NotificationCenterManager
        }
        return notificationCenterManager
    }

    var notificationCenterManager: NotificationCenterManager {
        AppNotificationCenterManager()
    }

    // ReposRepository
    private var _reposRepository: ReposRepository {
        if let overridenDep = overrides[.reposRepository] {
            return overridenDep as! ReposRepository
        }
        return reposRepository
    }

    var reposRepository: ReposRepository {
        AppReposRepository(githubApi: _gitHubAPI, db: _database)
    }

    // ReposViewModel
    private var _reposViewModel: ReposViewModel {
        if let overridenDep = overrides[.reposViewModel] {
            return overridenDep as! ReposViewModel
        }
        return reposViewModel
    }

    var reposViewModel: ReposViewModel {
        AppReposViewModel(reposRepository: _reposTellerRepository, keyValueStorage: _keyValueStorage)
    }

    // StartupUtil
    private var _startupUtil: StartupUtil {
        if let overridenDep = overrides[.startupUtil] {
            return overridenDep as! StartupUtil
        }
        return startupUtil
    }

    var startupUtil: StartupUtil {
        AppStartupUtil(coreDataManager: _coreDataManager)
    }

    // ThemeManager
    private var _themeManager: ThemeManager {
        if let overridenDep = overrides[.themeManager] {
            return overridenDep as! ThemeManager
        }
        return themeManager
    }

    var themeManager: ThemeManager {
        AppThemeManager(keyValueStorage: _keyValueStorage)
    }

    // ThreadUtil
    private var _threadUtil: ThreadUtil {
        if let overridenDep = overrides[.threadUtil] {
            return overridenDep as! ThreadUtil
        }
        return threadUtil
    }

    var threadUtil: ThreadUtil {
        AppThreadUtil()
    }

    // UserManager
    private var _userManager: UserManager {
        if let overridenDep = overrides[.userManager] {
            return overridenDep as! UserManager
        }
        return userManager
    }

    var userManager: UserManager {
        AppUserManager(storage: _keyValueStorage, secureStorage: _secureStorage)
    }

    // UserRepository
    private var _userRepository: UserRepository {
        if let overridenDep = overrides[.userRepository] {
            return overridenDep as! UserRepository
        }
        return userRepository
    }

    var userRepository: UserRepository {
        AppUserRepository(githubApi: _gitHubAPI, jsonAdapter: _jsonAdapter)
    }

    // Bundle (custom. property getter provided via extension)
    private var _bundle: Bundle {
        if let overridenDep = overrides[.bundle] {
            return overridenDep as! Bundle
        }
        return bundle
    }

    // CoreDataManager (singleton)
    private var _coreDataManager: CoreDataManager {
        if let overridenDep = overrides[.coreDataManager] {
            return overridenDep as! CoreDataManager
        }
        return coreDataManager
    }

    private let _coreDataManager_queue = DispatchQueue(label: "DI_get_coreDataManager_queue")
    private var _coreDataManager_shared: CoreDataManager?
    var coreDataManager: CoreDataManager {
        _coreDataManager_queue.sync {
            if let overridenDep = self.overrides[.coreDataManager] {
                return overridenDep as! CoreDataManager
            }
            let res = _coreDataManager_shared ?? _get_coreDataManager()
            _coreDataManager_shared = res
            return res
        }
    }

    private func _get_coreDataManager() -> CoreDataManager {
        CoreDataManager()
    }

    // RemoteConfigAdapter (custom. property getter provided via extension)
    private var _remoteConfigAdapter: RemoteConfigAdapter {
        if let overridenDep = overrides[.remoteConfigAdapter] {
            return overridenDep as! RemoteConfigAdapter
        }
        return remoteConfigAdapter
    }

    // DataDestroyer
    private var _dataDestroyer: DataDestroyer {
        if let overridenDep = overrides[.dataDestroyer] {
            return overridenDep as! DataDestroyer
        }
        return dataDestroyer
    }

    var dataDestroyer: DataDestroyer {
        DataDestroyer(keyValueStorage: _keyValueStorage, database: _database, pendingTasks: _pendingTasks)
    }

    // Database
    private var _database: Database {
        if let overridenDep = overrides[.database] {
            return overridenDep as! Database
        }
        return database
    }

    var database: Database {
        Database(coreDataManager: _coreDataManager)
    }

    // FileStorage (singleton)
    private var _fileStorage: FileStorage {
        if let overridenDep = overrides[.fileStorage] {
            return overridenDep as! FileStorage
        }
        return fileStorage
    }

    private let _fileStorage_queue = DispatchQueue(label: "DI_get_fileStorage_queue")
    private var _fileStorage_shared: FileStorage?
    var fileStorage: FileStorage {
        _fileStorage_queue.sync {
            if let overridenDep = self.overrides[.fileStorage] {
                return overridenDep as! FileStorage
            }
            let res = _fileStorage_shared ?? _get_fileStorage()
            _fileStorage_shared = res
            return res
        }
    }

    private func _get_fileStorage() -> FileStorage {
        FileMangerFileStorage(bundle: _bundle)
    }

    // GitHubRequestRunner (custom. property getter provided via extension)
    private var _gitHubRequestRunner: GitHubRequestRunner {
        if let overridenDep = overrides[.gitHubRequestRunner] {
            return overridenDep as! GitHubRequestRunner
        }
        return gitHubRequestRunner
    }

    // SecureStorage
    private var _secureStorage: SecureStorage {
        if let overridenDep = overrides[.secureStorage] {
            return overridenDep as! SecureStorage
        }
        return secureStorage
    }

    var secureStorage: SecureStorage {
        KeychainAccessSecureStorage()
    }

    // GitHubMoyaProvider (custom. property getter provided via extension)
    private var _gitHubMoyaProvider: GitHubMoyaProvider {
        if let overridenDep = overrides[.gitHubMoyaProvider] {
            return overridenDep as! GitHubMoyaProvider
        }
        return gitHubMoyaProvider
    }

    // MoyaResponseProcessor
    private var _moyaResponseProcessor: MoyaResponseProcessor {
        if let overridenDep = overrides[.moyaResponseProcessor] {
            return overridenDep as! MoyaResponseProcessor
        }
        return moyaResponseProcessor
    }

    var moyaResponseProcessor: MoyaResponseProcessor {
        MoyaResponseProcessor(jsonAdapter: _jsonAdapter)
    }

    // EventBus
    private var _eventBus: EventBus {
        if let overridenDep = overrides[.eventBus] {
            return overridenDep as! EventBus
        }
        return eventBus
    }

    var eventBus: EventBus {
        NotificationCenterEventBus(notificationCenter: _notificationCenterManager, activityLogger: _activityLogger)
    }

    // ReposDataSource
    private var _reposDataSource: ReposDataSource {
        if let overridenDep = overrides[.reposDataSource] {
            return overridenDep as! ReposDataSource
        }
        return reposDataSource
    }

    var reposDataSource: ReposDataSource {
        ReposDataSource(reposRepository: _reposRepository)
    }

    // RepositoryDao
    private var _repositoryDao: RepositoryDao {
        if let overridenDep = overrides[.repositoryDao] {
            return overridenDep as! RepositoryDao
        }
        return repositoryDao
    }

    var repositoryDao: RepositoryDao {
        RepositoryDao(coreDataManager: _coreDataManager)
    }

    // StringReplaceUtil
    private var _stringReplaceUtil: StringReplaceUtil {
        if let overridenDep = overrides[.stringReplaceUtil] {
            return overridenDep as! StringReplaceUtil
        }
        return stringReplaceUtil
    }

    var stringReplaceUtil: StringReplaceUtil {
        StringReplaceUtil(environment: _environment)
    }

    // JsonAdapter
    private var _jsonAdapter: JsonAdapter {
        if let overridenDep = overrides[.jsonAdapter] {
            return overridenDep as! JsonAdapter
        }
        return jsonAdapter
    }

    var jsonAdapter: JsonAdapter {
        SwiftJsonAdpter()
    }

    // ReposTellerRepository (custom. property getter provided via extension)
    private var _reposTellerRepository: ReposTellerRepository {
        if let overridenDep = overrides[.reposTellerRepository] {
            return overridenDep as! ReposTellerRepository
        }
        return reposTellerRepository
    }

    // RepositorySyncService
    private var _repositorySyncService: RepositorySyncService {
        if let overridenDep = overrides[.repositorySyncService] {
            return overridenDep as! RepositorySyncService
        }
        return repositorySyncService
    }

    var repositorySyncService: RepositorySyncService {
        TellerRepositorySyncService(reposRepository: _reposTellerRepository, keyValueStorage: _keyValueStorage, logger: _activityLogger)
    }

    // UserDefaults (custom. property getter provided via extension)
    private var _userDefaults: UserDefaults {
        if let overridenDep = overrides[.userDefaults] {
            return overridenDep as! UserDefaults
        }
        return userDefaults
    }

    // KeyValueStorage
    private var _keyValueStorage: KeyValueStorage {
        if let overridenDep = overrides[.keyValueStorage] {
            return overridenDep as! KeyValueStorage
        }
        return keyValueStorage
    }

    var keyValueStorage: KeyValueStorage {
        UserDefaultsKeyValueStorage(userDefaults: _userDefaults)
    }

    // PendingTasks
    private var _pendingTasks: PendingTasks {
        if let overridenDep = overrides[.pendingTasks] {
            return overridenDep as! PendingTasks
        }
        return pendingTasks
    }

    var pendingTasks: PendingTasks {
        WendyPendingTasks()
    }
}
