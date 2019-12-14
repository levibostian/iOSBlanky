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
    case startupUtil
    case themeManager
    case threadUtil
    case coreDataManager
    case bundle
    case database
    case remoteConfigProvider
    case secureStorage
    case moyaResponseProcessor
    case eventBus
    case reposDataSource
    case reposViewModel
    case repositoryDao
    case jsonAdapter
    case repositorySyncService
    case userCredsManager
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
        case .activityLogger: return activityLogger as! T
        case .backgroundJobRunner: return backgroundJobRunner as! T
        case .environment: return environment as! T
        case .gitHubAPI: return gitHubAPI as! T
        case .notificationCenterManager: return notificationCenterManager as! T
        case .startupUtil: return startupUtil as! T
        case .themeManager: return themeManager as! T
        case .threadUtil: return threadUtil as! T
        case .coreDataManager: return coreDataManager as! T
        case .bundle: return bundle as! T
        case .database: return database as! T
        case .remoteConfigProvider: return remoteConfigProvider as! T
        case .secureStorage: return secureStorage as! T
        case .moyaResponseProcessor: return moyaResponseProcessor as! T
        case .eventBus: return eventBus as! T
        case .reposDataSource: return reposDataSource as! T
        case .reposViewModel: return reposViewModel as! T
        case .repositoryDao: return repositoryDao as! T
        case .jsonAdapter: return jsonAdapter as! T
        case .repositorySyncService: return repositorySyncService as! T
        case .userCredsManager: return userCredsManager as! T
        case .keyValueStorage: return keyValueStorage as! T
        case .userManager: return userManager as! T
        case .pendingTasks: return pendingTasks as! T
        }
    }

    /**
     Use the property accessors below to inject pre-typed dependencies.
     */

    // ActivityLogger
    var activityLogger: ActivityLogger {
        if let overridenDep = self.overrides[.activityLogger] {
            return overridenDep as! ActivityLogger
        }
        return AppActivityLogger(environment: environment)
    }

    // BackgroundJobRunner
    var backgroundJobRunner: BackgroundJobRunner {
        if let overridenDep = self.overrides[.backgroundJobRunner] {
            return overridenDep as! BackgroundJobRunner
        }
        return AppBackgroundJobRunner(logger: activityLogger, pendingTasks: pendingTasks, repositorySyncService: repositorySyncService)
    }

    // Environment
    var environment: Environment {
        if let overridenDep = self.overrides[.environment] {
            return overridenDep as! Environment
        }
        return AppEnvironment()
    }

    // GitHubAPI
    var gitHubAPI: GitHubAPI {
        if let overridenDep = self.overrides[.gitHubAPI] {
            return overridenDep as! GitHubAPI
        }
        return AppGitHubApi(gitHubMoyaProvider: gitHubMoyaProvider, jsonAdapter: jsonAdapter, responseProcessor: moyaResponseProcessor)
    }

    // NotificationCenterManager
    var notificationCenterManager: NotificationCenterManager {
        if let overridenDep = self.overrides[.notificationCenterManager] {
            return overridenDep as! NotificationCenterManager
        }
        return AppNotificationCenterManager()
    }

    // StartupUtil
    var startupUtil: StartupUtil {
        if let overridenDep = self.overrides[.startupUtil] {
            return overridenDep as! StartupUtil
        }
        return AppStartupUtil(coreDataManager: coreDataManager)
    }

    // ThemeManager
    var themeManager: ThemeManager {
        if let overridenDep = self.overrides[.themeManager] {
            return overridenDep as! ThemeManager
        }
        return AppThemeManager(keyValueStorage: keyValueStorage)
    }

    // ThreadUtil
    var threadUtil: ThreadUtil {
        if let overridenDep = self.overrides[.threadUtil] {
            return overridenDep as! ThreadUtil
        }
        return AppThreadUtil()
    }

    // CoreDataManager (singleton)
    private let _coreDataManager_queue = DispatchQueue(label: "DI_get_coreDataManager_queue")
    private var _coreDataManager_shared: CoreDataManager?
    var coreDataManager: CoreDataManager {
        return _coreDataManager_queue.sync {
            if let overridenDep = self.overrides[.coreDataManager] {
                return overridenDep as! CoreDataManager
            }
            let res = _coreDataManager_shared ?? _coreDataManager()
            _coreDataManager_shared = res
            return res
        }
    }

    private func _coreDataManager() -> CoreDataManager {
        return CoreDataManager(threadUtil: threadUtil)
    }

    // Database
    var database: Database {
        if let overridenDep = self.overrides[.database] {
            return overridenDep as! Database
        }
        return Database(repositoryDao: repositoryDao)
    }

    // RemoteConfigProvider
    var remoteConfigProvider: RemoteConfigProvider {
        if let overridenDep = self.overrides[.remoteConfigProvider] {
            return overridenDep as! RemoteConfigProvider
        }
        return FirebaseRemoteConfig(logger: activityLogger)
    }

    // SecureStorage
    var secureStorage: SecureStorage {
        if let overridenDep = self.overrides[.secureStorage] {
            return overridenDep as! SecureStorage
        }
        return KeychainAccessSecureStorage(userManager: userManager)
    }

    // MoyaResponseProcessor
    var moyaResponseProcessor: MoyaResponseProcessor {
        if let overridenDep = self.overrides[.moyaResponseProcessor] {
            return overridenDep as! MoyaResponseProcessor
        }
        return MoyaResponseProcessor(jsonAdapter: jsonAdapter, activityLogger: activityLogger, eventBus: eventBus)
    }

    // EventBus
    var eventBus: EventBus {
        if let overridenDep = self.overrides[.eventBus] {
            return overridenDep as! EventBus
        }
        return NotificationCenterEventBus(notificationCenter: notificationCenterManager, activityLogger: activityLogger)
    }

    // ReposDataSource
    var reposDataSource: ReposDataSource {
        if let overridenDep = self.overrides[.reposDataSource] {
            return overridenDep as! ReposDataSource
        }
        return ReposDataSource(githubApi: gitHubAPI, db: database)
    }

    // ReposViewModel
    var reposViewModel: ReposViewModel {
        if let overridenDep = self.overrides[.reposViewModel] {
            return overridenDep as! ReposViewModel
        }
        return ReposViewModel(reposRepository: reposRepository, keyValueStorage: keyValueStorage)
    }

    // RepositoryDao
    var repositoryDao: RepositoryDao {
        if let overridenDep = self.overrides[.repositoryDao] {
            return overridenDep as! RepositoryDao
        }
        return RepositoryDao(coreDataManager: coreDataManager)
    }

    // JsonAdapter
    var jsonAdapter: JsonAdapter {
        if let overridenDep = self.overrides[.jsonAdapter] {
            return overridenDep as! JsonAdapter
        }
        return SwiftJsonAdpter()
    }

    // RepositorySyncService
    var repositorySyncService: RepositorySyncService {
        if let overridenDep = self.overrides[.repositorySyncService] {
            return overridenDep as! RepositorySyncService
        }
        return TellerRepositorySyncService(reposRepository: reposRepository, logger: activityLogger)
    }

    // UserCredsManager
    var userCredsManager: UserCredsManager {
        if let overridenDep = self.overrides[.userCredsManager] {
            return overridenDep as! UserCredsManager
        }
        return UserCredsManager(userManager: userManager, secureStorage: secureStorage)
    }

    // KeyValueStorage
    var keyValueStorage: KeyValueStorage {
        if let overridenDep = self.overrides[.keyValueStorage] {
            return overridenDep as! KeyValueStorage
        }
        return UserDefaultsKeyValueStorage(userDefaults: userDefaults)
    }

    // UserManager
    var userManager: UserManager {
        if let overridenDep = self.overrides[.userManager] {
            return overridenDep as! UserManager
        }
        return UserManager(storage: keyValueStorage)
    }

    // PendingTasks
    var pendingTasks: PendingTasks {
        if let overridenDep = self.overrides[.pendingTasks] {
            return overridenDep as! PendingTasks
        }
        return WendyPendingTasks()
    }
}
