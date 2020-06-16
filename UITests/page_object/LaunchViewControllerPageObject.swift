import Foundation
import XCTest

class LaunchViewControllerPageObject {
    let app: XCUIApplication

    typealias AId = LaunchViewController.AccessibilityId

    var usernameTextField: XCUIElement {
        app.textFields[AId.usernameTextField.rawValue]
    }

    var goButton: XCUIElement {
        app.buttons[AId.goButton.rawValue]
    }

    var stateOfDataLabel: XCUIElement! {
        app.staticTexts[AId.stateOfDataLabel.rawValue]
    }

    var fetchingDataStatusLabel: XCUIElement! {
        app.staticTexts[AId.fetchingDataStatusLabel.rawValue]
    }

    var userHasNoRepos: XCUIElement! {
        app.staticTexts["User does not have any repos."]
    }

    func numberReposLabel(_ numRepos: Int) -> XCUIElement {
        app.staticTexts["Num of repos for user: \(numRepos)"]
    }

    init(app: XCUIApplication) {
        self.app = app
    }
}
