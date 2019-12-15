import Foundation
import RxSwift
import XCTest

class ReposDataSourceTests: UnitTest {
    var dataSource: ReposDataSource!

    var githubApiMock: GitHubAPIMock!
    var database: Database!

    var disposeBag: DisposeBag!

    let defaultRequirements = ReposDataSource.Requirements(githubUsername: "username")

    override func setUp() {
        githubApiMock = GitHubAPIMock()
        database = Database(coreDataManager: CoreDataManager.initTesting())

        disposeBag = DisposeBag()

        dataSource = ReposDataSource(githubApi: githubApiMock, db: database)
    }

    func test_saveReposForUser_observeReposForUser_expectObserveWhatGotSaved() {
        let githubUsername = "username_for_testing_here"
        let requirements = ReposDataSource.Requirements(githubUsername: githubUsername)

        let emptyCache = try! dataSource.observeCache(requirements: requirements)
            .toBlocking()
            .first()!

        XCTAssertTrue(emptyCache.isEmpty)

        let newCache = [
            RepoFake.repoForUser(username: githubUsername).fake
        ]

        try! dataSource.saveCache(newCache, requirements: requirements)

        let expectNewCache = expectation(description: "Expect new cache")
        dataSource.observeCache(requirements: requirements)
            .filter { !$0.isEmpty }
            .subscribe(onNext: { newCacheAfterSave in
                XCTAssertEqual(newCache, newCacheAfterSave)

                expectNewCache.fulfill()
            }).disposed(by: disposeBag)

        waitForExpectations()
    }
}
