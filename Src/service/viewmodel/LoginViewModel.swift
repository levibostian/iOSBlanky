import Foundation
import RxSwift
import UIKit

protocol LoginViewModel: AutoMockable {
    func loginUser(token: String) -> Single<Result<TokenExchangeResponseVo, HttpRequestError>>
}

// sourcery: InjectRegister = "LoginViewModel"
class AppLoginViewModel: LoginViewModel {
    private let userManager: UserManager
    private let userRepository: UserRepository
    private let bundle: Bundle
    private let logger: ActivityLogger

    init(userManager: UserManager, dataDestroyer: DataDestroyer, userRepository: UserRepository, bundle: Bundle, logger: ActivityLogger) {
        self.userManager = userManager
        self.userRepository = userRepository
        self.bundle = bundle
        self.logger = logger
    }

    func loginUser(token: String) -> Single<Result<TokenExchangeResponseVo, HttpRequestError>> {
        userRepository.exchangeToken(token)
            .do(onSuccess: { result in
                if case .success(let successfulResponse) = result {
                    self.userManager.userId = successfulResponse.user.id
                    self.userManager.authToken = successfulResponse.user.accessToken

                    self.logger.appEventOccurred(.login, extras: [
                        .method: "Passwordless"
                    ])
                    self.logger.setUserId(id: String(successfulResponse.user.id))
                }
            }).subscribeOn(RxSchedulers.background).observeOn(RxSchedulers.ui)
    }
}
