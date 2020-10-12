@testable import App
import RxSwift
import Teller
import XCTest

class LoginViewControllerTest: ViewControllerUnitTest {
    var viewController: LoginViewController!

    var delegate: LoginViewControllerDelegateMock!
    var loginViewModelMock: LoginViewModelMock!
    var userManagerMock: UserManagerMock!

    override var viewControllerToTest: UIViewController {
        viewController
    }

    override var allAccessibilityIdentifiers: [AccessibilityIdentifier] {
        LoginViewController.AccessibilityId.allCases.ids
    }

    typealias VC = LoginViewController
    typealias AccessibleId = VC.AccessibilityId

    override func setUp() {
        loginViewModelMock = LoginViewModelMock()
        DI.shared.override(.loginViewModel, value: loginViewModelMock, forType: LoginViewModel.self)

        viewController = LoginViewController()
        delegate = LoginViewControllerDelegateMock()
        viewController.delegate = delegate

        super.setUp()
    }

    override func loadViewController() {
        fatalError("Wrong load function called.")
    }

    func loadViewController(arg: LoginViewController.Arg) {
        viewController.arg = arg

        super.loadViewController()
    }

    func test_coldStart_expectLoadingViewShown() {
        loginViewModelMock.loginUserTokenReturnValue = Single.never()

        loadViewController(arg: .token(token: "token"))

        XCTestViewVisibility(shown: [
            AccessibleId.loadingView.rawValue
        ], hidden: [
            AccessibleId.errorView.rawValue
        ])

        XCTAssertFalse(delegate.mockCalled)
    }

    func test_givenFailedLogin_expectErrorViewShown() {
        loginViewModelMock.loginUserTokenReturnValue = Single.just(Result.failure(HttpRequestError.getNoInternetConnection()))

        loadViewController(arg: .token(token: "token"))

        XCTestViewVisibility(shown: [
            AccessibleId.errorView.rawValue
        ], hidden: [
            AccessibleId.loadingView.rawValue
        ])

        XCTAssertNotNil(viewController.emptyView.buttons[LoginViewController.EmptyButtons.retry.rawValue])
        XCTAssertEqual(viewController.emptyView.buttons.count, 1)
    }

    func test_givenFailedLogin_givenRetry_expectTryLoginAgain() {
        loginViewModelMock.loginUserTokenReturnValue = Single.just(Result.failure(HttpRequestError.getNoInternetConnection()))

        loadViewController(arg: .token(token: "token"))

        XCTestViewVisibility(shown: [
            AccessibleId.errorView.rawValue
        ], hidden: [
            AccessibleId.loadingView.rawValue
        ])

        XCTAssertEqual(loginViewModelMock.loginUserTokenCallsCount, 1)

        loginViewModelMock.loginUserTokenReturnValue = Single.never()
        viewController.buttonPressed(id: LoginViewController.EmptyButtons.retry.rawValue)

        // See if loading view shows up again after retry pressed.
        XCTestViewVisibility(shown: [
            AccessibleId.loadingView.rawValue
        ], hidden: [
            AccessibleId.errorView.rawValue
        ])

        XCTAssertEqual(loginViewModelMock.loginUserTokenCallsCount, 2)

        XCTAssertFalse(delegate.mockCalled)
    }

    func test_givenSuccessfulLogin_expectTellDelegate() {
        loginViewModelMock.loginUserTokenReturnValue = Single.just(Result.success(TokenExchangeResponseVo(user: LoggedInUserVo.fake.randomLoggedIn)))

        loadViewController(arg: .token(token: "token"))

        XCTAssertTrue(delegate.userLoggedInSuccessfullyCalled)
    }
}
