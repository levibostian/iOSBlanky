import Foundation

struct LoggedInUserVo: Codable, Equatable, Hashable {
    let id: Double
    let email: String
    let accessToken: String?
}
