import Foundation
import UIKit

extension UIWindow {
    func dismissAllViewControllers(animated: Bool, completion: (() -> Void)?, viewControllerToPresent: UIViewController?) {
        rootViewController?.dismiss(animated: animated, completion: completion)

        if let viewControllerToPresent = viewControllerToPresent {
            rootViewController = viewControllerToPresent
            makeKeyAndVisible()
        }
    }
}
