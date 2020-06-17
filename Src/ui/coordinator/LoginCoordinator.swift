import Foundation
import SwiftCoordinator
import UIKit

protocol LoginCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: LoginCoordinator)
}

class LoginCoordinator: PresentationCoordinator {
    var childCoordinators: [Coordinator] = []
    var rootViewController: LoginViewController

    weak var delegate: LoginCoordinatorDelegate?

    init(token: String) {
        self.rootViewController = LoginViewController()

        rootViewController.arg = LoginViewController.Arg.token(token: token)
    }

    func start() {
        rootViewController.delegate = self
    }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func userLoggedInSuccessfully() {
        delegate?.didFinish(self)
    }
}
