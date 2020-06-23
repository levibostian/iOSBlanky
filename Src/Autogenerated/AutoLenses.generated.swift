// swiftlint:disable variable_name
// swiftlint:disable trailing_newline

import Foundation

infix operator *~: MultiplicationPrecedence
infix operator |>: AdditionPrecedence

struct Lens<Whole, Part> {
    let get: (Whole) -> Part
    let set: (Part, Whole) -> Whole
}

func * <A, B, C>(lhs: Lens<A, B>, rhs: Lens<B, C>) -> Lens<A, C> {
    Lens<A, C>(get: { a in rhs.get(lhs.get(a)) },
               set: { c, a in lhs.set(rhs.set(c, lhs.get(a)), a) })
}

func *~ <A, B>(lhs: Lens<A, B>, rhs: B) -> (A) -> A {
    { a in lhs.set(rhs, a) }
}

func |> <A, B>(x: A, f: (A) -> B) -> B {
    f(x)
}

func |> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    { g(f($0)) }
}

extension AppState {
    static let reposLens = Lens<AppState, [Repo]?>(get: { $0.repos },
                                                   set: { repos, appstate in
                                                       AppState(repos: repos, previousReposSearchUsername: appstate.previousReposSearchUsername, loggedInUser: appstate.loggedInUser, networkQueue: appstate.networkQueue, mainMenuCta: appstate.mainMenuCta)
        })
    static let previousReposSearchUsernameLens = Lens<AppState, String?>(get: { $0.previousReposSearchUsername },
                                                                         set: { previousReposSearchUsername, appstate in
                                                                             AppState(repos: appstate.repos, previousReposSearchUsername: previousReposSearchUsername, loggedInUser: appstate.loggedInUser, networkQueue: appstate.networkQueue, mainMenuCta: appstate.mainMenuCta)
        })
    static let loggedInUserLens = Lens<AppState, LoggedInUserVo?>(get: { $0.loggedInUser },
                                                                  set: { loggedInUser, appstate in
                                                                      AppState(repos: appstate.repos, previousReposSearchUsername: appstate.previousReposSearchUsername, loggedInUser: loggedInUser, networkQueue: appstate.networkQueue, mainMenuCta: appstate.mainMenuCta)
        })
    static let networkQueueLens = Lens<AppState, [NetworkQueueItem]?>(get: { $0.networkQueue },
                                                                      set: { networkQueue, appstate in
                                                                          AppState(repos: appstate.repos, previousReposSearchUsername: appstate.previousReposSearchUsername, loggedInUser: appstate.loggedInUser, networkQueue: networkQueue, mainMenuCta: appstate.mainMenuCta)
        })
    static let mainMenuCtaLens = Lens<AppState, CTA?>(get: { $0.mainMenuCta },
                                                      set: { mainMenuCta, appstate in
                                                          AppState(repos: appstate.repos, previousReposSearchUsername: appstate.previousReposSearchUsername, loggedInUser: appstate.loggedInUser, networkQueue: appstate.networkQueue, mainMenuCta: mainMenuCta)
        })

    // Convenient set functions to edit a property of the immutable object
    func reposSet(_ repos: [Repo]?) -> AppState {
        AppState(repos: repos, previousReposSearchUsername: previousReposSearchUsername, loggedInUser: loggedInUser, networkQueue: networkQueue, mainMenuCta: mainMenuCta)
    }

    func previousReposSearchUsernameSet(_ previousReposSearchUsername: String?) -> AppState {
        AppState(repos: repos, previousReposSearchUsername: previousReposSearchUsername, loggedInUser: loggedInUser, networkQueue: networkQueue, mainMenuCta: mainMenuCta)
    }

    func loggedInUserSet(_ loggedInUser: LoggedInUserVo?) -> AppState {
        AppState(repos: repos, previousReposSearchUsername: previousReposSearchUsername, loggedInUser: loggedInUser, networkQueue: networkQueue, mainMenuCta: mainMenuCta)
    }

    func networkQueueSet(_ networkQueue: [NetworkQueueItem]?) -> AppState {
        AppState(repos: repos, previousReposSearchUsername: previousReposSearchUsername, loggedInUser: loggedInUser, networkQueue: networkQueue, mainMenuCta: mainMenuCta)
    }

    func mainMenuCtaSet(_ mainMenuCta: CTA?) -> AppState {
        AppState(repos: repos, previousReposSearchUsername: previousReposSearchUsername, loggedInUser: loggedInUser, networkQueue: networkQueue, mainMenuCta: mainMenuCta)
    }
}
