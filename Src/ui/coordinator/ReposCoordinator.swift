import Foundation
import SwiftCoordinator
import UIKit

class ReposCoordinator: NavigationCoordinator {
    var navigator: NavigatorType
    var childCoordinators: [Coordinator] = []
    var rootViewController: UINavigationController

    private let reposViewController: LaunchViewController

    init() {
        self.reposViewController = LaunchViewController()

        let navigationController = UINavigationController(rootViewController: reposViewController)
        navigator = Navigator(navigationController: navigationController)
        rootViewController = navigationController
    }

    func start() {
//        reposViewController.delegate = self
    }
}

// Learn more about Coordinators and the patterns on how to use them: https://gist.github.com/levibostian/08f74511c347e695b8448ff6b2fc02a8
