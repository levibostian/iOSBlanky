import Foundation
import RxSwift
import XCTest

class ReposRepositoryTests: UnitTest {
    var repository: ReposRepository!

    var githubApiMock: GitHubAPIMock!
    var database: Database!

    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        githubApiMock = GitHubAPIMock()
        database = Database(coreDataManager: CoreDataManager.initTesting())

        disposeBag = DisposeBag()

        repository = AppReposRepository(githubApi: githubApiMock, db: database)
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

        try! repository.replaceRepos(newRepos, forUsername: githubUsername)

        let expectNewCache = expectation(description: "Expect new cache")
        repository.observeRepos(forUsername: githubUsername)
            .subscribe(onNext: { newCacheAfterSave in
                XCTAssertEqual(newRepos, newCacheAfterSave)

                expectNewCache.fulfill()
            }).disposed(by: disposeBag)

        waitForExpectations()
    }
}
