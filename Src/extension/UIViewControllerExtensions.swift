import Foundation
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
    }
}

extension UIViewController {
    static let swizzle: Void = {
        let originalSelector = #selector(viewWillAppear(_:))
        let swizzledSelector = #selector(swizzledViewWillAppear(_:))
        Swizzler.swizzling(UIViewController.self, originalSelector, swizzledSelector)
    }()

    @objc func swizzledViewWillAppear(_ animated: Bool) {
        (self as? ThemableViewController)?.applyTheme() // This must exist here, or some of the properties set on the VC will not set for the theme.
        swizzledViewWillAppear(animated) // call the original method
    }
}
