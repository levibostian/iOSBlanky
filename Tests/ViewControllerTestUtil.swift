import Foundation
import UIKit
import XCTest

// Inspiration: https://albertodebortoli.com/2018/03/12/easy-view-controller-unit-testing/
class ViewControllerTestUtil {
    var rootWindow: UIWindow!

    func startup(_ viewController: UIViewController) {
        rootWindow = UIWindow(frame: UIScreen.main.bounds)

        rootWindow.isHidden = false
        rootWindow.rootViewController = viewController
        _ = viewController.view
        viewController.viewWillAppear(false)
        viewController.viewDidAppear(false)
    }

    func tearDown() {
        guard let rootWindow = rootWindow, let rootViewController = rootWindow.rootViewController else {
            XCTFail("tearDown() was called without startup() being called first")
            return
        }

        rootViewController.viewWillDisappear(false)
        rootViewController.viewDidDisappear(false)
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true

        self.rootWindow = nil
    }
}
