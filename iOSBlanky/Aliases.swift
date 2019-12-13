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

typealias DriveApiMoyaInstance = MoyaProvider<GitHubService>
