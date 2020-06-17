import Foundation
import UIKit

protocol MenuPresenter {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

extension UIViewController: MenuPresenter {}

/**
 Wrapper around whatever view we choose to be the "Menu" system for the app. At this time, it's an UIAlertController.
 */
class Menu {
    private let alertController: UIAlertController

    var title: String? {
        alertController.title
    }

    var message: String? {
        alertController.message
    }

    private(set) var actions: [String: () -> Void] = [:]

    init(title: String?, message: String?) {
        self.alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    }

    func addAction(_ title: String, handler: @escaping () -> Void) {
        // simply ignore request if title is not unique.
        guard !actions.keys.contains(title) else {
            return
        }

        alertController.addAction(UIAlertAction(title: title, style: .default, handler: { _ in
            handler()

            self.alertController.dismiss(animated: true, completion: nil)
        }))

        actions[title] = handler
    }

    var presentCallsCount = 0
    var presentCalled: Bool {
        presentCallsCount > 0
    }

    var presentInvocations: [(MenuPresenter, Bool, (() -> Void)?)] = [] // swiftlint:disable:this large_tuple
    func present(_ presenter: MenuPresenter, animated: Bool, completion: (() -> Void)? = nil) {
        presentCallsCount += 1
        presentInvocations.append((presenter, animated, completion))

        alertController.addAction(UIAlertAction(title: Strings.cancel.localized, style: .cancel, handler: { _ in
            self.alertController.dismiss(animated: true, completion: nil)
        }))

        presenter.present(alertController, animated: animated, completion: completion)
    }
}
