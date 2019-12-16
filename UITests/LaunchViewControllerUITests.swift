@testable import iOSBlanky
import RxSwift
import Teller
import XCTest

class LaunchViewControllerUITests: UITest {
    var viewController: LaunchViewControllerPageObject!

    override func setUp() {
        super.setUp()

        viewController = LaunchViewControllerPageObject(app: app)
    }

    override func waitForAfterLaunch() {
        waitForElementToAppear(element: viewController.goButton)
    }

    func test_coldStart() {
        launchApp()

        XCTAssertTrue(viewController.goButton.exists)
        XCTAssertTrue(viewController.usernameTextField.exists)
    }

    func test_getReposForUser() {
        let givenUsername = "levibostian"
        let reposResponse: [Repo] = [
            RepoFake.repoForUser(username: givenUsername).fake
        ]
        let launchState = LaunchAppState(networkQueue: [
            LaunchAppState.NetworkQueueItem(code: 200, response: jsonAdapter.toJsonArray(reposResponse).string())
        ], userState: nil)

        launchApp(launchState)

        viewController.usernameTextField.tap()
        viewController.usernameTextField.typeText(givenUsername)
        viewController.goButton.tap()

        waitForElementToAppear(element: viewController.numberReposLabel(reposResponse.count))
    }

    func test_reposDontExistForUser() {
        let launchState = LaunchAppState(networkQueue: [
            LaunchAppState.NetworkQueueItem(code: 404, response: "")
        ], userState: nil)

        launchApp(launchState)

        viewController.usernameTextField.tap()
        viewController.usernameTextField.typeText("levibostian")
        viewController.goButton.tap()

        waitForElementToAppear(element: viewController.userHasNoRepos)
    }
}
