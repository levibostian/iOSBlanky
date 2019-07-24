import Foundation
import RxSwift

class ReposViewModel {
    private var reposRepository: ReposRepository
    private var githubUsernameRepository: GitHubUsernameRepository

    init(reposRepository: ReposRepository, githubUsernameRepository: GitHubUsernameRepository) {
        self.reposRepository = reposRepository
        self.githubUsernameRepository = githubUsernameRepository

        if let existingGitHubUsername: GitHubUsername = githubUsernameRepository.dataSource.value {
            reposRepository.requirements = ReposDataSourceRequirements(githubUsername: existingGitHubUsername)
        }
    }

    func setGitHubUsernameForRepos(_ username: GitHubUsername) {
        githubUsernameRepository.dataSource.saveData(data: username)
        reposRepository.requirements = ReposDataSourceRequirements(githubUsername: username)
    }

    func observeRepos() -> Observable<StateOnlineData<[Repo]>> {
        return reposRepository.observe()
            .observeOn(MainScheduler.instance)
    }

    func observeGitHubUsername() -> Observable<StateLocalData<GitHubUsername>> {
        return githubUsernameRepository.observe()
            .observeOn(MainScheduler.instance)
    }
}
