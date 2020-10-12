import Foundation
import RxSwift
import Teller

typealias ReposTellerRepository = TellerRepository<ReposDataSource>
// sourcery: InjectRegister = "ReposTellerRepository"
// sourcery: InjectCustom
extension ReposTellerRepository {}

extension DI {
    var reposTellerRepository: ReposTellerRepository {
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

    fileprivate let reposRepository: ReposRepository

    init(reposRepository: ReposRepository) {
        self.reposRepository = reposRepository
    }

    var maxAgeOfCache: Period = Period(unit: 3, component: .day)

    func fetchFreshCache(requirements: ReposDataSourceRequirements) -> Single<FetchResponse<[Repo], FetchError>> {
        reposRepository.getUserRepos(username: requirements.githubUsername)
    }

    func saveCache(_ fetchedData: [Repo], requirements: ReposDataSourceRequirements) throws {
        try reposRepository.replaceRepos(fetchedData, forUsername: requirements.githubUsername).sync()
    }

    func observeCache(requirements: ReposDataSourceRequirements) -> Observable<[Repo]> {
        reposRepository.observeRepos(forUsername: requirements.githubUsername)
    }

    func isCacheEmpty(_ cache: [Repo], requirements _: ReposDataSourceRequirements) -> Bool {
        cache.isEmpty
    }
}
