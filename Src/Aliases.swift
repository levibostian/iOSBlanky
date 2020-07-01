import Swapper
typealias SwapperView = Swapper.SwapperView
typealias SwapperViewConfig = Swapper.SwapperViewConfig

import Empty
typealias EmptyView = Empty.EmptyView
typealias EmptyViewDelegate = Empty.EmptyViewDelegate
typealias EmptyViewButtonTag = Empty.EmptyViewButtonTag
typealias EmptyViewConfigPreset = Empty.EmptyViewConfigPreset
typealias EmptyViewConfig = Empty.EmptyViewConfig

import PleaseHold
typealias PleaseHoldView = PleaseHold.PleaseHoldView
typealias PleaseHoldViewConfigPreset = PleaseHold.PleaseHoldViewConfigPreset
typealias PleaseHoldViewConfig = PleaseHold.PleaseHoldViewConfig

import enum Teller.RefreshResult
typealias RefreshResult = Teller.RefreshResult

import class Teller.CacheState
typealias CacheState = Teller.CacheState

import RxSwift
class Schedulers {
    static var main: SchedulerType {
        MainScheduler.instance
    }

    static var background: SchedulerType {
        ConcurrentDispatchQueueScheduler(qos: .background)
    }
}

typealias DisposeBag = RxSwift.DisposeBag
typealias Disposable = RxSwift.Disposable
typealias Single = RxSwift.Single
typealias Observable = RxSwift.Observable

import Moya

typealias GitHubMoyaProvider = MoyaProvider<GitHubService>
// sourcery: InjectRegister = "GitHubMoyaProvider"
// sourcery: InjectCustom
extension GitHubMoyaProvider {}

extension DI {
    var gitHubMoyaProvider: GitHubMoyaProvider {
        let plugins: [PluginType] = [
            MoyaAppendHeadersPlugin(userManager: self.inject(.userManager)),
            HttpLoggerMoyaPlugin(logger: self.inject(.activityLogger))
        ]

        return MoyaProvider<GitHubService>(plugins: plugins)
    }
}

import Boquila

typealias RemoteConfigAdapter = Boquila.RemoteConfigAdapter
typealias RemoteConfigAdapterPlugin = Boquila.RemoteConfigAdapterPlugin

// sourcery: InjectRegister = "UserDefaults"
// sourcery: InjectCustom
extension UserDefaults {}

extension DI {
    var userDefaults: UserDefaults {
        UserDefaults.standard
    }
}
