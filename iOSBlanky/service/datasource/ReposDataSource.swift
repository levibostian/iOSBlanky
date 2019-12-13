import Foundation
import RxSwift
import Teller

typealias ReposRepository = Repository<ReposDataSource>

class ReposDataSourceRequirements: RepositoryRequirements {
    let githubUsername: String
    var tag: RepositoryRequirements.Tag {
        return "Repos for GitHub username: \(githubUsername)"
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

class ReposDataSource: RepositoryDataSource {
    typealias Cache = [Repo]
    typealias Requirements = ReposDataSourceRequirements
    typealias FetchResult = [Repo]

    fileprivate let githubApi: GitHubAPI
    fileprivate let db: Database

    init(githubApi: GitHubAPI, db: Database) {
        self.githubApi = githubApi
        self.db = db
    }

    var maxAgeOfCache: Period = Period(unit: 3, component: .day)

    func fetchFreshCache(requirements: ReposDataSourceRequirements) -> Single<FetchResponse<[Repo]>> {
        return githubApi.getUserRepos(username: requirements.githubUsername)
    }

    func saveCache(_ fetchedData: [Repo], requirements: ReposDataSourceRequirements) throws {
        db.repositoryDao.replaceRepos(fetchedData, forUsername: requirements.githubUsername)
    }

    func observeCache(requirements: ReposDataSourceRequirements) -> Observable<[Repo]> {
        return db.repositoryDao.observeRepos(forUsername: requirements.githubUsername)
    }

    func isCacheEmpty(_ cache: [Repo], requirements: ReposDataSourceRequirements) -> Bool {
        return cache.isEmpty
    }
}
