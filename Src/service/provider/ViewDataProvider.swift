import Foundation
import RxSwift
import Teller

protocol ViewDataProvider: AutoMockable {
    var loginViewController: LoginViewController.ViewData { get }
}

extension AppViewDataProvider {
    static var loginViewController_id: String {
        "login_viewcontroller_viewdata"
    }

    static var loginViewController_default: LoginViewController.ViewData {
        LoginViewController.ViewData(loadingTitle: Strings.loggingIntoAppTitle.localized, loadingMessage: Strings.loggingIntoAppMessage.localized)
    }
}

// sourcery: InjectRegister = "ViewDataProvider"
class AppViewDataProvider: ViewDataProvider {
    private let remoteConfigAdapter: RemoteConfigAdapter

    init(remoteConfigAdapter: RemoteConfigAdapter) {
        self.remoteConfigAdapter = remoteConfigAdapter
    }

    var loginViewController: LoginViewController.ViewData {
        remoteConfigAdapter.getValue(id: AppViewDataProvider.loginViewController_id, defaultValue: AppViewDataProvider.loginViewController_default)
    }
}
