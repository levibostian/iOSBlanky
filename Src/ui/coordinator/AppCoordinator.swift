import Foundation
import SwiftCoordinator
import UIKit

/**
 Exists to contain UIWindow to display the root VC.
 */
final class AppCoordinator: RootCoordinator {
    var childCoordinators: [Coordinator] = []
    var rootViewController = AppRootViewController()

    let window: UIWindow

    init(window: UIWindow) {
        self.window = window

        showViewController(rootViewController)
    }

    func start() {
        goToReposSectionOfApp()
    }

    func startUserLogin(token: String) {
        let loginCoordinator = LoginCoordinator(token: token)
        loginCoordinator.delegate = self

        addChildCoordinator(loginCoordinator)
        loginCoordinator.start()
        rootViewController.set(childViewController: loginCoordinator.rootViewController)

        window.dismissAllViewControllers(animated: false, completion: nil, viewControllerToPresent: rootViewController)
    }

    private func goToReposSectionOfApp() {
        let coordinator = ReposCoordinator()
        addChildCoordinator(coordinator)
        coordinator.start()
        rootViewController.set(childViewController: coordinator.rootViewController)

        window.dismissAllViewControllers(animated: false, completion: nil, viewControllerToPresent: rootViewController)
    }
}

extension AppCoordinator: LoginCoordinatorDelegate {
    func didFinish(_ coordinator: LoginCoordinator) {
        dismissCoordinator(coordinator, animated: true)

        goToReposSectionOfApp()
    }
}
