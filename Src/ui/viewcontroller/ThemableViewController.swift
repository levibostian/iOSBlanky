import Foundation
import UIKit

protocol ThemableViewController {
    var navigationBarTitle: String? { get }
    var navigationBarBackButtonText: String? { get }
    var themeManager: ThemeManager { get }
    var viewController: UIViewController { get }

    // optional override this function to make changes to the ViewController looks.
    func customThemeChanges()
}

extension ThemableViewController {
    var currentTheme: Theme? {
        viewController.appDelegate?.themeManager.currentTheme
    }

    func applyTheme() {
        viewController.appDelegate?.themeManager.applyTheme(to: self)
    }
}
