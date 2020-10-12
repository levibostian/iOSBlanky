@testable import App
import Foundation
import RxSwift
import XCTest

class ReposRepositoryTests: RepositoryTest {
    var repository: ReposRepository!

    var githubApiMock: GitHubAPIMock!

    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        githubApiMock = GitHubAPIMock()

        disposeBag = DisposeBag()

        repository = AppReposRepository(githubApi: githubApiMock, reposDao: DI.shared.inject(.repositoryDao), schedulers: schedulers)
    }

    func test_saveReposForUser_observeReposForUser_expectObserveWhatGotSaved() {
        let githubUsername = "username_for_testing_here"

        let emptyCache = try! repository.observeRepos(forUsername: githubUsername)
            .toBlocking()
            .first()!

        XCTAssertTrue(emptyCache.isEmpty)

        let newRepos = [
            Repo.fake.repoForUser(username: githubUsername)
        ]

        try! repository.replaceRepos(newRepos, forUsername: githubUsername).sync()

        let expectNewCache = expectation(description: "Expect new cache")
        repository.observeRepos(forUsername: githubUsername)
            .subscribe(onNext: { newCacheAfterSave in
                XCTAssertEqual(newRepos, newCacheAfterSave)

                expectNewCache.fulfill()
            }).disposed(by: disposeBag)

        waitForExpectations()
    }
}
