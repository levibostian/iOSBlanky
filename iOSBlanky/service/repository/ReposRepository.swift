import Foundation
import RxSwift
import Teller

class ReposDataSourceRequirements: OnlineRepositoryGetDataRequirements {
    let githubUsername: String
    var tag: OnlineRepositoryGetDataRequirements.Tag {
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

class ReposDataSource: OnlineRepositoryDataSource {
    typealias Cache = [Repo]
    typealias GetDataRequirements = ReposDataSourceRequirements
    typealias FetchResult = [Repo]

    fileprivate let githubApi: GitHubAPI
    fileprivate let db: Database

    fileprivate var observeCache: PublishSubject<[Repo]>?

    init(githubApi: GitHubAPI, db: Database) {
        self.githubApi = githubApi
        self.db = db
    }

    var maxAgeOfData: Period = Period(unit: 3, component: .day)

    func fetchFreshData(requirements: ReposDataSourceRequirements) -> Single<FetchResponse<[Repo]>> {
        return githubApi.getUserRepos(username: requirements.githubUsername)
    }

    func saveData(_ fetchedData: [Repo], requirements: ReposDataSourceRequirements) {
        db.repositoryDao.replaceRepos(fetchedData, forUsername: requirements.githubUsername)
    }

    private func newDataSaved(forUsername: GitHubUsername) {
        observeCache?.on(.next(db.repositoryDao.getRepos(forUsername: forUsername)))
    }

    func observeCachedData(requirements: ReposDataSourceRequirements) -> Observable<[Repo]> {
        observeCache?.dispose()
        observeCache = PublishSubject()

        newDataSaved(forUsername: requirements.githubUsername)

        return observeCache!
    }

    func isDataEmpty(_ cache: [Repo], requirements: ReposDataSourceRequirements) -> Bool {
        return cache.isEmpty
    }
}

class ReposRepository: OnlineRepository<ReposDataSource> {
    required init(dataSource: ReposDataSource) {
        super.init(dataSource: dataSource)
    }
}
