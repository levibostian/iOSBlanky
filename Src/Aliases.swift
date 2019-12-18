import Swapper
typealias SwapperView = Swapper.SwapperView

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

import RxSwift
class Schedulers {
    static var main: SchedulerType {
        return MainScheduler.instance
    }

    static var background: SchedulerType {
        return ConcurrentDispatchQueueScheduler(qos: .background)
    }
}

import Moya

typealias GitHubMoyaProvider = MoyaProvider<GitHubService>
// sourcery: InjectRegister = "GitHubMoyaProvider"
// sourcery: InjectCustom
extension GitHubMoyaProvider {}

extension DI {
    var gitHubMoyaProvider: GitHubMoyaProvider {
        let plugins: [PluginType] = [
            MoyaAppendHeadersPlugin(userCredsManager: self.inject(.userCredsManager)),
            HttpLoggerMoyaPlugin(logger: self.inject(.activityLogger))
        ]

        return MoyaProvider<GitHubService>(plugins: plugins)
    }
}

// sourcery: InjectRegister = "UserDefaults"
// sourcery: InjectCustom
extension UserDefaults {}

extension DI {
    var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
}
