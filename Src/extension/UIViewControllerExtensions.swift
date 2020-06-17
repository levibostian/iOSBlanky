import Foundation
import SafariServices
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate? {
        // Must be optional because when running **unit** tests, you cannot cast successfully. `UIApplication.shared.delegate` will be equal to the unit test app delegate, but it can't cast as the app's app delegate
        UIApplication.shared.delegate as? AppDelegate
    }

    func addChildViewController(_ childViewController: UIViewController, addView: ((UIView) -> Void)?) {
        childViewController.willMove(toParent: self)

        if let addView = addView {
            addView(childViewController.view)
        } else {
            view.addSubview(childViewController.view)
        }

        addChild(childViewController)

        childViewController.didMove(toParent: self)
    }

    func scroll(_ scrollView: UIScrollView, toView viewToScrollTo: UIView, animated: Bool) {
        scrollView.setContentOffset(CGPoint(x: 0, y: viewToScrollTo.y), animated: animated)
    }

    func getErrorAlert(title: String?, message: String?) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: Strings.ok.localized, style: .default, handler: { _ in
            controller.dismiss(animated: true, completion: nil)
        }))

        return controller
    }

    // Call when you press a "Done" button, for example, do to tasks such as closing the keyboard.
    func doneEditing() {
        view.endEditing(true) // close keyboard
    }

    func runOnMain(_ run: @escaping () -> Void) {
        DispatchQueue.main.asyncOrSyncIfMain(run)
    }

    func getButton(withTitle title: String) -> UIButton? {
        var foundButton: UIButton?

        view.allSubviews.forEach { subview in
            if let button = subview as? UIButton {
                if button.title(for: .normal) == title {
                    foundButton = button
                }
            }
        }

        return foundButton
    }
}

extension UIViewController {
    static let swizzle: Void = {
        let originalSelector = #selector(viewWillAppear(_:))
        let swizzledSelector = #selector(swizzledViewWillAppear(_:))
        Swizzler.swizzling(UIViewController.self, originalSelector, swizzledSelector)
    }()

    @objc func swizzledViewWillAppear(_ animated: Bool) {
        guard let themeableViewController = self as? ThemableViewController else {
            return
        }

        themeableViewController.themeManager.applyTheme(to: themeableViewController) // This must exist here, or some of the properties set on the VC will not set for the theme.

        swizzledViewWillAppear(animated) // call the original method
    }
}

extension UIViewController {
    func setUnitTesting() {
        UIView.setAnimationsEnabled(false)
    }

    func setOrientation(_ orientation: UIInterfaceOrientation) {
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
    }
}
