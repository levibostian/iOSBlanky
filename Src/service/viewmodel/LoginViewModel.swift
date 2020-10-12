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
    private let logger: ActivityLogger
    private let schedulers: RxSchedulers

    init(userManager: UserManager, dataDestroyer _: DataDestroyer, userRepository: UserRepository, logger: ActivityLogger, schedulers: RxSchedulers) {
        self.userManager = userManager
        self.userRepository = userRepository
        self.logger = logger
        self.schedulers = schedulers
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
            }).subscribeOn(schedulers.background).observeOn(schedulers.ui)
    }
}
