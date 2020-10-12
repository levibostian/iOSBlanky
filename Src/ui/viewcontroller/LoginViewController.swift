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

    struct ViewData: Codable {
        let loadingTitle: String
        let loadingMessage: String?
    }

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

    let swapperView: SwapperView<SwapViews> = {
        let view = SwapperView<SwapViews>()
        return view
    }()

    lazy var pleaseHoldView: PleaseHoldView = {
        let view = PleaseHoldView()
        view.title = viewData.loadingTitle
        view.message = viewData.loadingMessage
        view.accessibilityIdentifier = AccessibilityId.loadingView.rawValue
        return view
    }()

    enum SwapViews: String, CustomStringConvertible {
        case loadingView
        case errorView

        var description: String {
            rawValue
        }
    }

    let emptyView: EmptyView = {
        let view = EmptyView()
        view.accessibilityIdentifier = AccessibilityId.errorView.rawValue
        return view
    }()

    enum EmptyButtons: String {
        case retry
    }

    fileprivate let viewDataProvider: ViewDataProvider = DI.shared.inject(.viewDataProvider)
    fileprivate let loginViewModel: LoginViewModel = DI.shared.inject(.loginViewModel)
    private let logger: ActivityLogger = DI.shared.inject(.activityLogger)

    lazy var viewData: ViewData = {
        self.viewDataProvider.loginViewController
    }()

    fileprivate let disposeBag = DisposeBag()
    fileprivate var loginUserDisposable: Disposable?

    override func viewDidLoad() {
        super.viewDidLoad()

        if arg == nil {
            fatalError("You forgot to set arguments of this VC")
        }

        swapperView.setSwappingViews([
            (.loadingView, pleaseHoldView),
            (.errorView, emptyView)
        ], swapTo: .loadingView)

        view.addSubview(swapperView)

        view.setNeedsUpdateConstraints()

        setupViews()

        try! swapperView.swapTo(.loadingView, onComplete: nil)

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
                try! self.swapperView.swapTo(.loadingView, onComplete: nil)
            })
            .subscribe(onSuccess: { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success:
                    self.delegate?.userLoggedInSuccessfully()
                case .failure(let error):
                    self.emptyView.message = error.localizedDescription
                    try! self.swapperView.swapTo(.errorView, onComplete: nil)
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
