import Foundation
import RxSwift

protocol ReposRepository: AutoMockable {
    func getUserRepos(username: String) -> Single<Result<[Repo], HttpRequestError>>
    func observeRepos(forUsername: String) -> Observable<[Repo]>
    func replaceRepos(_ repos: [Repo], forUsername: String) -> DaoWrite
}

// sourcery: InjectRegister = "ReposRepository"
class AppReposRepository: ReposRepository {
    fileprivate let githubApi: GitHubAPI
    fileprivate let reposDao: RepositoryDao
    private let schedulers: RxSchedulers

    init(githubApi: GitHubAPI, reposDao: RepositoryDao, schedulers: RxSchedulers) {
        self.githubApi = githubApi
        self.reposDao = reposDao
        self.schedulers = schedulers
    }

    func getUserRepos(username: String) -> Single<Result<[Repo], HttpRequestError>> {
        githubApi.getUserRepos(username: username)
    }

    func observeRepos(forUsername username: String) -> Observable<[Repo]> {
        reposDao.getRepos(forUsername: username).observe()
            .map { (models) -> [Repo] in
                models.map { $0.toRepo() }
            }
            .subscribeOn(schedulers.background)
    }

    func replaceRepos(_ repos: [Repo], forUsername username: String) -> DaoWrite {
        reposDao.replaceRepos(repos, forUsername: username)
    }
}
