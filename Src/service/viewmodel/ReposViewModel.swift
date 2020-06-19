import Foundation
import RxSwift
import Teller

protocol ReposViewModel: AutoMockable {
    var gitHubUsername: GitHubUsername? { get set }
    func observeRepos() -> Observable<CacheState<[Repo]>>
    func observeGitHubUsername() -> Observable<GitHubUsername>
}

// sourcery: InjectRegister = "ReposViewModel"
class AppReposViewModel: ReposViewModel {
    private let reposRepository: ReposTellerRepository
    private let keyValueStorage: KeyValueStorage

    private let githubUsernameUserDefaultsKey = "githubUsernameUserDefaultsKey"

    var gitHubUsername: GitHubUsername? {
        get {
            keyValueStorage.string(forKey: .lastUsernameSearch)
        }
        set {
            keyValueStorage.setString(newValue, forKey: .lastUsernameSearch)

            if let newValue = newValue {
                reposRepository.requirements = ReposDataSourceRequirements(githubUsername: newValue)
            }
        }
    }

    init(reposRepository: ReposTellerRepository, keyValueStorage: KeyValueStorage) {
        self.reposRepository = reposRepository
        self.keyValueStorage = keyValueStorage

        if let existingGitHubUsername = gitHubUsername {
            reposRepository.requirements = ReposDataSourceRequirements(githubUsername: existingGitHubUsername)
        }
    }

    func observeRepos() -> Observable<CacheState<[Repo]>> {
        reposRepository.observe()
            .observeOn(MainScheduler.instance)
    }

    func observeGitHubUsername() -> Observable<GitHubUsername> {
        keyValueStorage.observeString(forKey: .lastUsernameSearch)
    }
}
