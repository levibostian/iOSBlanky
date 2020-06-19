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
        assertAllAccessibilityIdentifiers([shown, hidden])

        shown.forEach { identifier in
            guard let shownView = viewControllerToTest.view.findByAccessibilityIdentifier(identifier: identifier) else {
                fatalError("View with identifier, \(identifier), not found in VC view.")
            }
            XCTAssertTrue(shownView.isShown)
        }

        hidden.forEach { identifier in
            // we check if view is either hidden, or is removed as a subview which means it is hidden.
            if let hiddenView = viewControllerToTest.view.findByAccessibilityIdentifier(identifier: identifier) {
                XCTAssertTrue(hiddenView.isHidden)
            }
        }
    }

    func XCTestViewShown(_ view: UIView, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(view.isShown)
    }

    // Asserts that we are checking *all* identifiers for the ViewController. No more, no less.
    private func assertAllAccessibilityIdentifiers(_ identifiers: [[AccessibilityIdentifier]]) {
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
            fatalError("Identifiers, \(allIdentifiers), are missing from the test check.")
        }
    }
}
