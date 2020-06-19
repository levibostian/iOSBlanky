class AppStateManager {
    let reposRepository: ReposRepository
    let gitHubMoyaProvider: MoyaProviderMocker<GitHubService>

    init(reposRepository: ReposRepository, gitHubMoyaProvider: MoyaProviderMocker<GitHubService>) {
        self.reposRepository = reposRepository
        self.gitHubMoyaProvider = gitHubMoyaProvider
    }

    // Called by the app when it launches to save all this data.
    func set(appState: AppState) {
        if let username = appState.previousReposSearchUsername {
            if let repos = appState.repos {
                try! reposRepository.replaceRepos(repos, forUsername: username)
            }
        }

        if let networkQueue = appState.networkQueue {
            networkQueue.forEach { queueItem in
                if queueItem.isErrorType {
                    gitHubMoyaProvider.queueNetworkError(queueItem.responseError!.error)
                } else {
                    gitHubMoyaProvider.queueResponse(queueItem.code!, data: queueItem.response!)
                }
            }
        }

        //
        //                        launchArguments.extras.keyStorageStringValues.forEach { arg in
        //                            let (key, value) = arg
        //                            keyValueStorage.setString(value, forKey: key)
        //                        }
        //                        launchArguments.extras.keyStorageIntValues.forEach { arg in
        //                            let (key, value) = arg
        //                            keyValueStorage.setInt(value, forKey: key)
        //                        }
        //
        //                        remoteConfigHelper.set(launchArguments.extras.remoteConfig)
        //
        //                        if let launchUserState = launchArguments.userState {
        //                            let userManager = DI.shared.userManager
        //
        //                            userManager.userId = launchUserState.id
        //                        }
    }
}
