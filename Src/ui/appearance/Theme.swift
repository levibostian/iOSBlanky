import Empty
import Foundation
import PleaseHold
import UIKit

struct Theme {
    let name: String

    let navigationBarTextColor: UIColor
    let navigationBarItemColor: UIColor // color of bar items
    let navigationBarColor: UIColor
    let statusBarStyle: UIStatusBarStyle
    let emptyViewStyle: EmptyViewConfigPreset
    let pleaseHoldViewStyle: PleaseHoldViewConfigPreset
}

protocol ThemeManager {
    var currentTheme: Theme { get set }

    func applyAppTheme(_ theme: Theme)
    func applyTheme(to viewController: ThemableViewController)
}

// sourcery: InjectRegister = "ThemeManager"
class AppThemeManager: ThemeManager {
    private let keyValueStorage: KeyValueStorage
    private let currentThemeKey = "currentThemeKey"

    private let themes: [Theme]!
    private let defaultTheme: Theme!

    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage

        self.defaultTheme = Theme(name: "light",
                                  navigationBarTextColor: UIColor.white,
                                  navigationBarItemColor: UIColor.white,
                                  navigationBarColor: UIColor.darkGray,
                                  statusBarStyle: .lightContent,
                                  emptyViewStyle: EmptyViewConfig.light,
                                  pleaseHoldViewStyle: PleaseHoldViewConfig.light)
        self.themes = [
            defaultTheme
        ]
    }

    var currentTheme: Theme {
        set {
            guard themes.contains(where: { $0.name == newValue.name }) else {
                fatalError("Cannot save current theme: \(newValue) when themes: \(String(describing: themes))")
            }

            keyValueStorage.set(newValue.name, forKey: currentThemeKey)
        }
        get {
            guard let themeName = keyValueStorage.string(forKey: currentThemeKey) else {
                return defaultTheme
            }

            return themes.first(where: { $0.name == themeName })!
        }
    }

    func applyAppTheme(_ theme: Theme) {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = theme.navigationBarColor
        UINavigationBar.appearance().tintColor = theme.navigationBarItemColor
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: theme.navigationBarTextColor]

        EmptyViewConfig.shared = theme.emptyViewStyle.config
        PleaseHoldViewConfig.shared = theme.pleaseHoldViewStyle.config
    }

    func applyTheme(to viewController: ThemableViewController) {
        func setNavigationBarTitle(_ text: String) {
            if viewController.navigationItem.titleView is UIButton {
                (viewController.navigationItem.titleView as! UIButton).setTitle(text, for: UIControl.State.normal) // swiftlint:disable:this force_cast
            } else {
                viewController.navigationController?.navigationBar.topItem?.title = text
            }
        }
        func setBackButtonText(_ text: String) {
            let backItem = UIBarButtonItem()
            backItem.title = text
            viewController.navigationItem.backBarButtonItem = backItem
        }

        setNavigationBarTitle(viewController.navigationBarTitle ?? " ")
        setBackButtonText(viewController.navigationBarBackButtonText ?? " ")

        viewController.setNeedsStatusBarAppearanceUpdate() // To get the status bar style to work.
    }
}
