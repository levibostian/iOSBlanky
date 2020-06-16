import Foundation
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
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
