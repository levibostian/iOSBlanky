import Foundation
import RxSwift
import Teller

typealias ReposRepository = TellerRepository<ReposDataSource>
// sourcery: InjectRegister = "ReposRepository"
// sourcery: InjectCustom
extension ReposRepository {}

extension DI {
    var reposRepository: ReposRepository {
        TellerRepository(dataSource: inject(.reposDataSource))
    }
}

class ReposDataSourceRequirements: RepositoryRequirements {
    let githubUsername: String
    var tag: RepositoryRequirements.Tag {
        "Repos for GitHub username: \(githubUsername)"
    }

    init(githubUsername: String) {
        self.githubUsername = githubUsername
    }
}

enum ResposApiError: Error, LocalizedError {
    case usernameDoesNotExist(username: String)

    var errorDescription: String? {
        switch self {
        case .usernameDoesNotExist(let username):
            return "The GitHub username \(username) does not exist." // comment: "GitHub returned 404 which means user does not exist.")
        }
    }
}

// sourcery: InjectRegister = "ReposDataSource"
class ReposDataSource: RepositoryDataSource {
    typealias Cache = [Repo]
    typealias Requirements = ReposDataSourceRequirements
    typealias FetchResult = [Repo]
    typealias FetchError = HttpRequestError

    fileprivate let githubApi: GitHubAPI
    fileprivate let db: Database

    init(githubApi: GitHubAPI, db: Database) {
        self.githubApi = githubApi
        self.db = db
    }

    var maxAgeOfCache: Period = Period(unit: 3, component: .day)

    func fetchFreshCache(requirements: ReposDataSourceRequirements) -> Single<FetchResponse<[Repo], FetchError>> {
        githubApi.getUserRepos(username: requirements.githubUsername)
    }

    func saveCache(_ fetchedData: [Repo], requirements: ReposDataSourceRequirements) throws {
        db.repositoryDao.replaceRepos(fetchedData, forUsername: requirements.githubUsername)
    }

    func observeCache(requirements: ReposDataSourceRequirements) -> Observable<[Repo]> {
        db.repositoryDao.observeRepos(forUsername: requirements.githubUsername)
    }

    func isCacheEmpty(_ cache: [Repo], requirements: ReposDataSourceRequirements) -> Bool {
        cache.isEmpty
    }
}
