import Foundation
import SnapKit
import UIKit

protocol LoginViewControllerDelegate: AnyObject, AutoMockable {
    func userLoggedInSuccessfully()
}

class LoginViewController: UIViewController {
    fileprivate var didSetupConstraints = false

    enum Arg {
        case token(token: String)
    }

    var arg: Arg?

    fileprivate var token: String? {
        guard case .token(let token) = self.arg else {
            return nil
        }

        return token
    }

    weak var delegate: LoginViewControllerDelegate?

    enum AccessibilityId: AccessibilityIdentifier, CaseIterable {
        case loadingView
        case errorView
    }

    let swapperView: SwapperView = {
        let view = SwapperView()
        return view
    }()

    let pleaseHoldView: PleaseHoldView = {
        let view = PleaseHoldView()
        view.title = Strings.loggingIntoAppTitle.localized
        view.message = Strings.loggingIntoAppMessage.localized
        view.accessibilityIdentifier = AccessibilityId.loadingView.rawValue
        return view
    }()

    enum SwapViews: String {
        case loadingView
        case errorView
    }

    let emptyView: EmptyView = {
        let view = EmptyView()
        view.accessibilityIdentifier = AccessibilityId.errorView.rawValue
        return view
    }()

    enum EmptyButtons: String {
        case retry
    }

    fileprivate let loginViewModel: LoginViewModel = DI.shared.inject(.loginViewModel)
    private let logger: ActivityLogger = DI.shared.inject(.activityLogger)

    fileprivate let disposeBag = DisposeBag()
    fileprivate var loginUserDisposable: Disposable?

    override func viewDidLoad() {
        super.viewDidLoad()

        if arg == nil {
            fatalError("You forgot to set arguments of this VC")
        }

        swapperView.setSwappingViews([
            (SwapViews.loadingView.rawValue, pleaseHoldView),
            (SwapViews.errorView.rawValue, emptyView)
        ])

        view.addSubview(swapperView)

        view.setNeedsUpdateConstraints()

        setupViews()

        try! swapperView.swapTo(SwapViews.loadingView.rawValue, onComplete: nil)

        populateView()
    }

    override func updateViewConstraints() {
        if !didSetupConstraints {
            swapperView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            didSetupConstraints = true
        }

        super.updateViewConstraints()
    }

    private func setupViews() {
        emptyView.delegate = self
        emptyView.addButton(id: EmptyButtons.retry.rawValue, message: Strings.retry.localized)
    }

    private func populateView() {
        loginUserDisposable?.dispose()

        loginUserDisposable = loginViewModel.loginUser(token: token!)
            .do(onSubscribe: {
                try! self.swapperView.swapTo(SwapViews.loadingView.rawValue, onComplete: nil)
                })
            .subscribe(onSuccess: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success:
                    self.delegate?.userLoggedInSuccessfully()
                case .failure(let error):
                    self.emptyView.message = error.localizedDescription
                    try! self.swapperView.swapTo(SwapViews.errorView.rawValue, onComplete: nil)
                }
                })

        disposeBag.insert(loginUserDisposable!)
    }
}

extension LoginViewController: EmptyViewDelegate {
    func buttonPressed(id: String) {
        guard let buttonPressed = EmptyButtons(rawValue: id) else {
            return
        }

        switch buttonPressed {
        case .retry:
            populateView()
        }
    }
}
