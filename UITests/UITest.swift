import Foundation
import UIKit
import XCTest

class UITest: XCTestCase {
    var app: XCUIApplication!
    var jsonAdapter: JsonAdapter!

    override func setUp() {
        jsonAdapter = DI.shared.jsonAdapter

        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }

    override class func tearDown() {
        DI.shared.resetOverrides()

        super.tearDown()
    }

    func waitForAfterLaunch() {
        // If there is any view to wait for which indicates the launch is done.
    }

    func launchApp(_ state: LaunchAppState? = nil) {
        app.launchEnvironment["launch_state"] = nil
        if let launchState = state {
            let stateString = jsonAdapter.toJson(launchState).string()

            app.launchEnvironment["launch_state"] = stateString
        }

        app.launch()

        waitForAfterLaunch()
    }
}

extension UITest {
    func waitForElementToAppear(element: XCUIElement, file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)

        waitForExpectations(timeout: 5) { (error) -> Void in
            if error != nil {
                let message = "Failed to find \(element) after 5 seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
            }
        }
    }
}
