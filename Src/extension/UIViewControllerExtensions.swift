import Foundation
import SafariServices
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate? {
        // Must be optional because when running **unit** tests, you cannot cast successfully. `UIApplication.shared.delegate` will be equal to the unit test app delegate, but it can't cast as the app's app delegate
        UIApplication.shared.delegate as? AppDelegate
    }

    func browse(to url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    // To present the VC over the current one, still showing the old one.
    // Call this before presenting the ViewController.
    // Thanks, https://gist.github.com/barbietunnie/e5547f35180436ac102cac52a15f8ca3
    func presentOverExisting() {
        modalPresentationStyle = .overCurrentContext
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

    var isSystemDarkModeEnabled: Bool {
        if #available(iOS 12, *) {
            return traitCollection.userInterfaceStyle == .dark
        } else {
            return false
        }
    }

    /**
     This function is to test out if Crashlytics is working for your app.

     How to get this to work:
     1. Call this function in your ViewController's viewDidLoad() function. Choose a ViewController that launches when your app launches for convenience.
     2. Run the app in XCode to your test device. You may need to enable CloudFlare 1.1.1.1 VPN proxy via the 1.1.1.1 app on your iPhone in case your proxy or network blocks Firebase or Crashlytics.
     3. When your app launches from XCode, immediately press the stop button in XCode to stop the debugging session in XCode with the app. If the crash happens while XCode is debugging, Crashlytics will not be called.
     4. Launch your app from the device. Wait for the app to close because it has crashed.
     5. Launch the app again which will make Crashlytics SDK send the report to Crashlytics.
     6. Wait about 5 minutes or so and you will then see a crash in your crashlytics dashboard.
     */
    func TESTCRASHLYTICS() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            fatalError("Testing crashltyics working")
        }
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
