import Empty
import Foundation
import PleaseHold
import UIKit

struct Theme {
    let name: String

    let textColor: UIColor
    let buttonColor: UIColor
    let viewControllerBackgroundColor: UIColor
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

    private let themes: [Theme]!
    private let defaultTheme: Theme!

    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage

        self.defaultTheme = Theme(name: "default",
                                  textColor: Colors.textColor.color,
                                  buttonColor: Colors.buttonColor.color,
                                  viewControllerBackgroundColor: Colors.backgroundColor.color,
                                  navigationBarTextColor: UIColor.white,
                                  navigationBarItemColor: Colors.navigationBarTintColor.color,
                                  navigationBarColor: Colors.navigationBarColor.color,
                                  statusBarStyle: .default,
                                  emptyViewStyle: DarkModeEnabledEmptyViewConfig(),
                                  pleaseHoldViewStyle: DarkModeEnabledPleaseHoldViewConfigPreset())

        self.themes = [
            defaultTheme
        ]
    }

    var currentTheme: Theme {
        set {
            guard themes.contains(where: { $0.name == newValue.name }) else {
                fatalError("Cannot save current theme: \(newValue) when themes: \(String(describing: themes))")
            }

            keyValueStorage.setString(newValue.name, forKey: .currentTheme)
        }
        get {
            guard let themeName = keyValueStorage.string(forKey: .currentTheme) else {
                return defaultTheme
            }

            return themes.first(where: { $0.name == themeName })!
        }
    }

    func applyAppTheme(_ theme: Theme) {
        styleNavigationBar(UINavigationBar.appearance(), theme: theme)

        UILabel.appearance().textColor = theme.textColor
        UIButton.appearance().setTitleColor(theme.buttonColor, for: .normal)
        UILabel.appearance(whenContainedInInstancesOf: [UIButton.self]).textColor = theme.buttonColor

        EmptyViewConfig.shared = theme.emptyViewStyle.config
        PleaseHoldViewConfig.shared = theme.pleaseHoldViewStyle.config
    }

    private func styleNavigationBar(_ navigationBar: UINavigationBar, theme: Theme) {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = theme.navigationBarColor
        navigationBar.tintColor = theme.navigationBarItemColor
        navigationBar.titleTextAttributes = [.foregroundColor: theme.navigationBarTextColor]
    }

    func applyTheme(to viewController: ThemableViewController) {
        let theme = viewController.themeManager.currentTheme
        let themeableViewController = viewController
        let viewController = viewController.viewController

        func setNavigationBarTitle(_ text: String) {
            if viewController.navigationItem.titleView is UIButton {
                (viewController.navigationItem.titleView as! UIButton).setTitle(text, for: UIControl.State.normal) // swiftlint:disable:this force_cast
            } else {
//                viewController.navigationController?.navigationBar.topItem?.title = text
                viewController.title = text
            }
        }
        func setBackButtonText(_ text: String) {
            let backItem = UIBarButtonItem()
            backItem.title = text
            viewController.navigationItem.backBarButtonItem = backItem
            viewController.navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
        }

        setNavigationBarTitle(themeableViewController.navigationBarTitle ?? " ")
        setBackButtonText(themeableViewController.navigationBarBackButtonText ?? " ")
        if let navigationBar = viewController.navigationController?.navigationBar {
            styleNavigationBar(navigationBar, theme: theme)
        }

        viewController.setNeedsStatusBarAppearanceUpdate() // To get the status bar style to work.

        viewController.view.backgroundColor = theme.viewControllerBackgroundColor

        themeableViewController.customThemeChanges()
    }
}
