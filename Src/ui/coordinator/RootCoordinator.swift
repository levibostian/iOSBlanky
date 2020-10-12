import Foundation
import SwiftCoordinator
import UIKit

/**
 Meant to be a Coordinator that is at the root of the UI which means that it maintains a UIWindow.
 */
protocol RootCoordinator: PresentationCoordinator {
    var window: UIWindow { get }
}

extension RootCoordinator {
    func showViewController(_ viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
