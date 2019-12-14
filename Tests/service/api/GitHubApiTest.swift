import Foundation
@testable import iOSBlanky
import RxBlocking
import RxSwift
import XCTest

class GitHubApiTests: UnitTest {
    private var moyaMocker: MoyaProviderMocker<GitHubService>!

    private var api: GitHubAPI!

    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()

        moyaMocker = MoyaProviderMocker()

        api = AppGitHubApi(gitHubMoyaProvider: moyaMocker.moyaProvider, jsonAdapter: DI.shared.jsonAdapter, responseProcessor: DI.shared.moyaResponseProcessor)
    }

    func test_getDriveRootFolderContents_givenSuccessfulResponse_expectReceiveResponse() {
        let givenResponse: [Repo] = [RepoFake.randomRepo.fake]

        moyaMocker.queueResponse(200, data: givenResponse)

        let actualResult = try! api.getUserRepos(username: "username")
            .toBlocking()
            .single()

        XCTAssertEqual(try actualResult.get(), givenResponse)
    }
}
