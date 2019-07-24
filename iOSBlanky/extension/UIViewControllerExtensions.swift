import Foundation
import UIKit

extension UIViewController {
    func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
    }

    func setBackButtonText(_ text: String = " ") {
        let backItem = UIBarButtonItem()
        backItem.title = text
        navigationItem.backBarButtonItem = backItem
    }

    func setNavigationBarTitle(_ text: String = " ") {
        if navigationItem.titleView is UIButton {
            (navigationItem.titleView as! UIButton).setTitle(text, for: UIControl.State.normal) // swiftlint:disable:this force_cast
        } else {
            navigationController?.navigationBar.topItem?.title = text
        }
    }
}
