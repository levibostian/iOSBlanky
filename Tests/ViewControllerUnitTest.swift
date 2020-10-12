@testable import App
import Foundation
import UIKit
import XCTest

class ViewControllerUnitTest: UnitTest {
    var viewControllerToTest: UIViewController {
        fatalError("Forgot to extend")
    }

    private var calledSetup = false

    var allAccessibilityIdentifiers: [AccessibilityIdentifier] {
        fatalError("Forgot to extend")
    }

    var viewControllerTestUtil = ViewControllerTestUtil()

    func loadViewController() {
        viewControllerTestUtil.startup(viewControllerToTest)
    }

    override func setUp() {
        super.setUp()

        viewControllerToTest.setUnitTesting()

        calledSetup = true
    }

    override func tearDown() {
        if !calledSetup {
            fatalError("You forgot to call ViewControllerUnitTest.setUp()")
        }

        super.tearDown()

        viewControllerTestUtil.tearDown()
    }
}

extension ViewControllerUnitTest {
    func XCTestViewVisibility(shown: [AccessibilityIdentifier], hidden: [AccessibilityIdentifier], file: StaticString = #file, line: UInt = #line) {
        assertAllAccessibilityIdentifiers([shown, hidden], file: file, line: line)

        shown.forEach { identifier in
            guard let shownView = viewControllerToTest.view.findByAccessibilityIdentifier(identifier: identifier) else {
                fatalError("View with identifier, \(identifier), not found in VC view.")
            }
            XCTAssertTrue(shownView.isShown, file: file, line: line)
        }

        hidden.forEach { identifier in
            // we check if view is either hidden, or is removed as a subview which means it is hidden.
            if let hiddenView = viewControllerToTest.view.findByAccessibilityIdentifier(identifier: identifier) {
                XCTAssertTrue(hiddenView.isHidden, file: file, line: line)
            }
        }
    }

    func XCTestViewShown(_ view: UIView, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(view.isShown, file: file, line: line)
    }

    // Asserts that we are checking *all* identifiers for the ViewController. No more, no less.
    private func assertAllAccessibilityIdentifiers(_ identifiers: [[AccessibilityIdentifier]], file: StaticString, line: UInt) {
        var allIdentifiers = allAccessibilityIdentifiers
        var seenIdentifiers: [AccessibilityIdentifier] = []

        identifiers.forEach { identifierSet in
            identifierSet.forEach { identifier in
                guard let foundIndex = allIdentifiers.firstIndex(where: { $0 == identifier }) else {
                    fatalError("Identifier, \(identifier), not found in all identifiers. All identifiers *must* contain all identifiers.")
                }
                if seenIdentifiers.contains(identifier) {
                    fatalError("Identifier, \(identifier), has already been seen. You can only use the identifier once in your check.")
                }

                allIdentifiers.remove(at: foundIndex)
                seenIdentifiers.append(identifier)
            }
        }

        if !allIdentifiers.isEmpty {
            XCTFail("Identifiers, \(allIdentifiers), are missing from the test check.", file: file, line: line)
        }
    }

    func XCTestButtonTargetSet(_ button: UIButton, file: StaticString = #file, line: UInt = #line) {
        if button.allTargets.isEmpty {
            XCTFail("No targets set on button", file: file, line: line)
        }
    }
}
