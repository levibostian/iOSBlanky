//
//  RepositorySyncService.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 7/24/19.
//  Copyright © 2019 Curiosity IO. All rights reserved.
//

import Foundation
import RxSwift
import Teller

protocol RepositorySyncService {
    func syncRepositories(onComplete: @escaping ([RefreshResult]) -> Void)
    func sync() -> UIBackgroundFetchResult
}

class TellerRepositorySyncService: RepositorySyncService {

    private let reposRepository: ReposRepository
    private let githubUsernameRepository: GitHubUsernameRepository

    private let syncQueue = DispatchQueue(label: "RepositorySyncService.syncQueue")
    private let syncDispatchGroup = DispatchGroup()

    private let disposeBag = DisposeBag()

    init(reposRepository: ReposRepository,
         githubUsernameRepository: GitHubUsernameRepository) {
        self.reposRepository = reposRepository
        self.githubUsernameRepository = githubUsernameRepository
    }

    func syncRepositories(onComplete: @escaping ([RefreshResult]) -> Void) {
        guard let usernameReposToFetch = githubUsernameRepository.dataSource.value else {
            onComplete([])
            return
        }

        var fetchResults: [RefreshResult] = []

        reposRepository.requirements = ReposDataSource.GetDataRequirements(githubUsername: usernameReposToFetch)

        try! reposRepository.refresh(force: false)
            .subscribe(onSuccess: { (result) in
                fetchResults.append(result)

                onComplete(fetchResults)
            }).disposed(by: disposeBag)
    }

    func sync() -> UIBackgroundFetchResult {
        return syncQueue.sync {
            syncDispatchGroup.enter()
            var backgroundFetchResult: UIBackgroundFetchResult!

            syncRepositories(onComplete: { (refreshResults) in
                let numberSuccessfulFetches = refreshResults.filter({ $0.didSucceed() }).count
                let numberSkippedTasks = refreshResults.filter({ $0.didSkip() }).count
                let numberFailedTasks = refreshResults.filter({ $0.didFail() }).count

                if refreshResults.isEmpty || numberSkippedTasks == refreshResults.count {
                    backgroundFetchResult = .noData
                } else if numberSuccessfulFetches >= numberFailedTasks {
                    backgroundFetchResult = .newData
                } else {
                    backgroundFetchResult = .failed
                }

                self.syncDispatchGroup.leave()
            })

            _ = syncDispatchGroup.wait(timeout: .distantFuture)
            return backgroundFetchResult
        }
    }

}
