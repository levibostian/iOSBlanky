@testable import App
import RxSwift
import Teller
import XCTest

class TakeScreenshots: UITest {
    var launchViewController: LaunchViewControllerPageObject!

    override func setUp() {
        super.setUp()

        setupSnapshot(app)

        launchViewController = LaunchViewControllerPageObject(app: app)
    }

    func screenshot(_ label: String) {
        snapshot(label)
    }

    override func waitForAfterLaunch() {
        waitForElementToAppear(element: launchViewController.goButton)
    }

    // All screenshots take place here. In 1 function.
    func test_takeScreenshots() {
        let givenUsername = "levibostian"
        let reposResponse: [Repo] = [
            RepoFake.repoForUser(username: givenUsername).fake
        ]
        let launchState = LaunchAppState(networkQueue: [
            LaunchAppState.NetworkQueueItem(code: 200, response: jsonAdapter.toJsonArray(reposResponse).string())
        ], userState: nil)

        launchApp(launchState)

        launchViewController.usernameTextField.tap()
        launchViewController.usernameTextField.typeText(givenUsername)

        screenshot("type")

        launchViewController.goButton.tap()
        waitForElementToAppear(element: launchViewController.numberReposLabel(reposResponse.count))

        screenshot("repos")
    }
}
