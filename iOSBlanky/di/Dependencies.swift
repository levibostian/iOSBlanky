import Foundation

enum Dependency: CaseIterable {
    case activityLogger
    case coreDataManager
    case repositoryDao
    case reposDataSource
    case reposRepository
    case reposViewModel
    case githubUsernameRepository
    case githubDataSource
    case moyaProvider
    case githubApi
    case jsonAdapter
    case database
    case eventBus
    case moyaResponseProcessor
    case remoteConfig
    case userManager
    case userCredsManager
    case keyValueStorage
    case secureStorage
    case repositorySyncService
    case threadUtil
    case startupUtil
}
