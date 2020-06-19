@testable import App
import Foundation

struct LoggedInUserVoFakes {
    var randomLoggedIn: LoggedInUserVo {
        LoggedInUserVo(id: 1, email: "\("".random(length: 10))@example.com", accessToken: "".random(length: 100))
    }
}

extension LoggedInUserVo {
    static var fake: LoggedInUserVoFakes {
        LoggedInUserVoFakes()
    }
}
