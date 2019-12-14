import Foundation
import RxSwift
import Teller

// sourcery: InjectRegister = "ReposViewModel"
class ReposViewModel {
    private let reposRepository: ReposRepository
    private let keyValueStorage: KeyValueStorage

    private let githubUsernameUserDefaultsKey = "githubUsernameUserDefaultsKey"

    var gitHubUsername: GitHubUsername? {
        get {
            return keyValueStorage.string(forKey: githubUsernameUserDefaultsKey)
        }
        set {
            keyValueStorage.set(newValue, forKey: githubUsernameUserDefaultsKey)

            if let newValue = newValue {
                reposRepository.requirements = ReposDataSourceRequirements(githubUsername: newValue)
            }
        }
    }

    init(reposRepository: ReposRepository, keyValueStorage: KeyValueStorage) {
        self.reposRepository = reposRepository
        self.keyValueStorage = keyValueStorage

        if let existingGitHubUsername = gitHubUsername {
            reposRepository.requirements = ReposDataSourceRequirements(githubUsername: existingGitHubUsername)
        }
    }

    func observeRepos() -> Observable<DataState<[Repo]>> {
        return reposRepository.observe()
            .observeOn(MainScheduler.instance)
    }

    func observeGitHubUsername() -> Observable<GitHubUsername> {
        return keyValueStorage.observeString(forKey: githubUsernameUserDefaultsKey)
    }
}
