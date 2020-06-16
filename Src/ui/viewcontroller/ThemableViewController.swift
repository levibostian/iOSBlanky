import Foundation
import UIKit

protocol ThemableViewController: UIViewController {
    var navigationBarTitle: String? { get }
    var navigationBarBackButtonText: String? { get }
    var themeManager: ThemeManager { get }

    // Note: Must set "View controller-based status bar appearance" to YES in Info.plist to work
    var preferredStatusBarStyle: UIStatusBarStyle { get }
}

extension ThemableViewController {
    var currentTheme: Theme {
        appDelegate.themeManager.currentTheme
    }

    func applyTheme() {
        appDelegate.themeManager.applyTheme(to: self)
    }
}
