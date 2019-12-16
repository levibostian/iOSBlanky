import Foundation
import XCTest

class LaunchViewControllerPageObject {
    let app: XCUIApplication

    typealias AId = LaunchViewController.AccessibilityId

    var usernameTextField: XCUIElement {
        return app.textFields[AId.usernameTextField.rawValue]
    }

    var goButton: XCUIElement {
        return app.buttons[AId.goButton.rawValue]
    }

    var stateOfDataLabel: XCUIElement! {
        return app.staticTexts[AId.stateOfDataLabel.rawValue]
    }

    var fetchingDataStatusLabel: XCUIElement! {
        return app.staticTexts[AId.fetchingDataStatusLabel.rawValue]
    }

    var userHasNoRepos: XCUIElement! {
        return app.staticTexts["User does not have any repos."]
    }

    func numberReposLabel(_ numRepos: Int) -> XCUIElement {
        return app.staticTexts["Num of repos for user: \(numRepos)"]
    }

    init(app: XCUIApplication) {
        self.app = app
    }
}
