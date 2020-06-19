import Foundation
import RxSwift

protocol ReposRepository: AutoMockable {
    func getUserRepos(username: String) -> Single<Result<[Repo], HttpRequestError>>
    func observeRepos(forUsername: String) -> Observable<[Repo]>
    func replaceRepos(_ repos: [Repo], forUsername: String) throws
}

// sourcery: InjectRegister = "ReposRepository"
class AppReposRepository: ReposRepository {
    fileprivate let githubApi: GitHubAPI
    fileprivate let db: Database

    init(githubApi: GitHubAPI, db: Database) {
        self.githubApi = githubApi
        self.db = db
    }

    func getUserRepos(username: String) -> Single<Result<[Repo], HttpRequestError>> {
        githubApi.getUserRepos(username: username)
    }

    func observeRepos(forUsername: String) -> Observable<[Repo]> {
        db.repositoryDao.observeRepos(forUsername: forUsername)
    }

    func replaceRepos(_ repos: [Repo], forUsername: String) throws {
        db.repositoryDao.replaceRepos(repos, forUsername: forUsername)
    }
}
