import Foundation

struct LaunchAppState: Codable {
    let networkQueue: [NetworkQueueItem]
    let userState: UserState?

    struct NetworkQueueItem: Codable {
        let code: Int
        let response: String
    }

    struct UserState: Codable {
        let id: Int
    }
}
