import Foundation

struct AppState: Codable, AutoLenses {
    let repos: [Repo]?
    let previousReposSearchUsername: String?
    let loggedInUser: LoggedInUserVo?

    let networkQueue: [NetworkQueueItem]?

    /*
     -----------------------------
     Do not forget to add logic to save this property in `AppStateManager`
     -----------------------------
     */

    // remote config values are *set* as properties in AppState. They are *saved* as remote config values. The test function should not care that they are remote config set.
    let mainMenuCta: CTA?

    struct NetworkQueueItem: Codable {
        let code: Int?
        let response: String?
        let responseError: NetworkQueueError?

        init(code: Int, response: String) {
            self.code = code
            self.response = response
            self.responseError = nil
        }

        init(responseError: NetworkQueueError) {
            self.code = nil
            self.response = nil
            self.responseError = responseError
        }

        var isErrorType: Bool {
            responseError != nil
        }

        enum NetworkQueueError: String, Codable {
            case noInternet
            case badInternet

            var error: Error {
                switch self {
                case .noInternet: return URLError(.notConnectedToInternet)
                case .badInternet: return URLError(.timedOut)
                }
            }
        }
    }

    func queueNetworkSuccess<T: Codable>(_ newQueueItem: (code: Int, response: T)) -> AppState {
        let jsonAdapter = DI.shared.jsonAdapter

        let networkQueueItemToAdd = NetworkQueueItem(code: newQueueItem.code, response: try! jsonAdapter.toJson(newQueueItem.response).string!)

        var newNetworkQueue = networkQueue ?? []
        newNetworkQueue.append(networkQueueItemToAdd)

        return AppState.networkQueueLens.set(newNetworkQueue, self)
    }

    func queueNetworkError(_ error: NetworkQueueItem.NetworkQueueError) -> AppState {
        let networkQueueItemToAdd = NetworkQueueItem(responseError: error)

        var newNetworkQueue = networkQueue ?? []
        newNetworkQueue.append(networkQueueItemToAdd)

        return AppState.networkQueueLens.set(newNetworkQueue, self)
    }
}

/*
 All constructors for `AppState`.
 */
extension AppState {
    static func freshAppInstall() -> AppState {
        AppState(repos: nil, previousReposSearchUsername: nil, loggedInUser: nil, networkQueue: nil, mainMenuCta: nil)
    }

    static func reposSearched(repos: [Repo], forUsername: String) -> AppState {
        AppState(repos: repos, previousReposSearchUsername: forUsername, loggedInUser: nil, networkQueue: nil, mainMenuCta: nil)
    }
}
