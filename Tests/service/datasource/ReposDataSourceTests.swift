import Foundation
import RxSwift
import XCTest

class ReposDataSourceTests: UnitTest {
    var dataSource: ReposDataSource!

    var reposRepositoryMock: ReposRepositoryMock!

    var disposeBag: DisposeBag!

    let defaultRequirements = ReposDataSource.Requirements(githubUsername: "username")

    override func setUp() {
        super.setUp()

        reposRepositoryMock = ReposRepositoryMock()

        disposeBag = DisposeBag()

        dataSource = ReposDataSource(reposRepository: reposRepositoryMock)
    }

    // At this time, there is little to no logic in the datasource. It's just a wrapper around the repository. Therefore, we are not testing it.
}
