// swiftlint:disable line_length
// swiftlint:disable variable_name
// swiftlint:disable large_tuple

import Foundation
import RxSwift
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

class ActivityLoggerMock: ActivityLogger {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - setUserId

    var setUserIdIdCallsCount = 0
    var setUserIdIdCalled: Bool {
        return setUserIdIdCallsCount > 0
    }

    var setUserIdIdReceivedId: String?
    var setUserIdIdReceivedInvocations: [String?] = []
    var setUserIdIdClosure: ((String?) -> Void)?

    func setUserId(id: String?) {
        mockCalled = true
        setUserIdIdCallsCount += 1
        setUserIdIdReceivedId = id
        setUserIdIdReceivedInvocations.append(id)
        setUserIdIdClosure?(id)
    }

    // MARK: - appEventOccurred

    var appEventOccurredExtrasFromCallsCount = 0
    var appEventOccurredExtrasFromCalled: Bool {
        return appEventOccurredExtrasFromCallsCount > 0
    }

    var appEventOccurredExtrasFromReceivedArguments: (event: String, extras: [String: Any]?, file: String)?
    var appEventOccurredExtrasFromReceivedInvocations: [(event: String, extras: [String: Any]?, file: String)] = []
    var appEventOccurredExtrasFromClosure: ((String, [String: Any]?, String) -> Void)?

    func appEventOccurred(_ event: String, extras: [String: Any]?, from file: String) {
        mockCalled = true
        appEventOccurredExtrasFromCallsCount += 1
        appEventOccurredExtrasFromReceivedArguments = (event: event, extras: extras, file: file)
        appEventOccurredExtrasFromReceivedInvocations.append((event: event, extras: extras, file: file))
        appEventOccurredExtrasFromClosure?(event, extras, file)
    }

    // MARK: - breadcrumb

    var breadcrumbExtrasFromCallsCount = 0
    var breadcrumbExtrasFromCalled: Bool {
        return breadcrumbExtrasFromCallsCount > 0
    }

    var breadcrumbExtrasFromReceivedArguments: (event: String, extras: [String: Any]?, file: String)?
    var breadcrumbExtrasFromReceivedInvocations: [(event: String, extras: [String: Any]?, file: String)] = []
    var breadcrumbExtrasFromClosure: ((String, [String: Any]?, String) -> Void)?

    func breadcrumb(_ event: String, extras: [String: Any]?, from file: String) {
        mockCalled = true
        breadcrumbExtrasFromCallsCount += 1
        breadcrumbExtrasFromReceivedArguments = (event: event, extras: extras, file: file)
        breadcrumbExtrasFromReceivedInvocations.append((event: event, extras: extras, file: file))
        breadcrumbExtrasFromClosure?(event, extras, file)
    }

    // MARK: - httpRequestEvent

    var httpRequestEventMethodUrlReqBodyCallsCount = 0
    var httpRequestEventMethodUrlReqBodyCalled: Bool {
        return httpRequestEventMethodUrlReqBodyCallsCount > 0
    }

    var httpRequestEventMethodUrlReqBodyReceivedArguments: (method: String, url: String, reqBody: String?)?
    var httpRequestEventMethodUrlReqBodyReceivedInvocations: [(method: String, url: String, reqBody: String?)] = []
    var httpRequestEventMethodUrlReqBodyClosure: ((String, String, String?) -> Void)?

    func httpRequestEvent(method: String, url: String, reqBody: String?) {
        mockCalled = true
        httpRequestEventMethodUrlReqBodyCallsCount += 1
        httpRequestEventMethodUrlReqBodyReceivedArguments = (method: method, url: url, reqBody: reqBody)
        httpRequestEventMethodUrlReqBodyReceivedInvocations.append((method: method, url: url, reqBody: reqBody))
        httpRequestEventMethodUrlReqBodyClosure?(method, url, reqBody)
    }

    // MARK: - httpSuccessEvent

    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount = 0
    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCalled: Bool {
        return httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount > 0
    }

    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments: (method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)?
    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations: [(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)] = []
    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyClosure: ((String, String, Int, String?, String?, String?) -> Void)?

    func httpSuccessEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        mockCalled = true
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount += 1
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments = (method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody)
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations.append((method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody))
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyClosure?(method, url, code, reqHeaders, resHeaders, resBody)
    }

    // MARK: - httpFailEvent

    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount = 0
    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCalled: Bool {
        return httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount > 0
    }

    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments: (method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)?
    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations: [(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)] = []
    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyClosure: ((String, String, Int, String?, String?, String?) -> Void)?

    func httpFailEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        mockCalled = true
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount += 1
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments = (method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody)
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations.append((method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody))
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyClosure?(method, url, code, reqHeaders, resHeaders, resBody)
    }

    // MARK: - errorOccurred

    var errorOccurredCallsCount = 0
    var errorOccurredCalled: Bool {
        return errorOccurredCallsCount > 0
    }

    var errorOccurredReceivedError: Error?
    var errorOccurredReceivedInvocations: [Error] = []
    var errorOccurredClosure: ((Error) -> Void)?

    func errorOccurred(_ error: Error) {
        mockCalled = true
        errorOccurredCallsCount += 1
        errorOccurredReceivedError = error
        errorOccurredReceivedInvocations.append(error)
        errorOccurredClosure?(error)
    }
}

class DebugActivityLoggerMock: DebugActivityLogger {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - identifyUser

    var identifyUserIdCallsCount = 0
    var identifyUserIdCalled: Bool {
        return identifyUserIdCallsCount > 0
    }

    var identifyUserIdReceivedId: String?
    var identifyUserIdReceivedInvocations: [String?] = []
    var identifyUserIdClosure: ((String?) -> Void)?

    func identifyUser(id: String?) {
        mockCalled = true
        identifyUserIdCallsCount += 1
        identifyUserIdReceivedId = id
        identifyUserIdReceivedInvocations.append(id)
        identifyUserIdClosure?(id)
    }

    // MARK: - logAppEvent

    var logAppEventExtrasCallsCount = 0
    var logAppEventExtrasCalled: Bool {
        return logAppEventExtrasCallsCount > 0
    }

    var logAppEventExtrasReceivedArguments: (message: String, extras: [String: Any]?)?
    var logAppEventExtrasReceivedInvocations: [(message: String, extras: [String: Any]?)] = []
    var logAppEventExtrasClosure: ((String, [String: Any]?) -> Void)?

    func logAppEvent(_ message: String, extras: [String: Any]?) {
        mockCalled = true
        logAppEventExtrasCallsCount += 1
        logAppEventExtrasReceivedArguments = (message: message, extras: extras)
        logAppEventExtrasReceivedInvocations.append((message: message, extras: extras))
        logAppEventExtrasClosure?(message, extras)
    }

    // MARK: - logDebug

    var logDebugExtrasCallsCount = 0
    var logDebugExtrasCalled: Bool {
        return logDebugExtrasCallsCount > 0
    }

    var logDebugExtrasReceivedArguments: (message: String, extras: [String: Any]?)?
    var logDebugExtrasReceivedInvocations: [(message: String, extras: [String: Any]?)] = []
    var logDebugExtrasClosure: ((String, [String: Any]?) -> Void)?

    func logDebug(_ message: String, extras: [String: Any]?) {
        mockCalled = true
        logDebugExtrasCallsCount += 1
        logDebugExtrasReceivedArguments = (message: message, extras: extras)
        logDebugExtrasReceivedInvocations.append((message: message, extras: extras))
        logDebugExtrasClosure?(message, extras)
    }

    // MARK: - logError

    var logErrorCallsCount = 0
    var logErrorCalled: Bool {
        return logErrorCallsCount > 0
    }

    var logErrorReceivedError: Error?
    var logErrorReceivedInvocations: [Error] = []
    var logErrorClosure: ((Error) -> Void)?

    func logError(_ error: Error) {
        mockCalled = true
        logErrorCallsCount += 1
        logErrorReceivedError = error
        logErrorReceivedInvocations.append(error)
        logErrorClosure?(error)
    }

    // MARK: - setUserId

    var setUserIdIdCallsCount = 0
    var setUserIdIdCalled: Bool {
        return setUserIdIdCallsCount > 0
    }

    var setUserIdIdReceivedId: String?
    var setUserIdIdReceivedInvocations: [String?] = []
    var setUserIdIdClosure: ((String?) -> Void)?

    func setUserId(id: String?) {
        mockCalled = true
        setUserIdIdCallsCount += 1
        setUserIdIdReceivedId = id
        setUserIdIdReceivedInvocations.append(id)
        setUserIdIdClosure?(id)
    }

    // MARK: - appEventOccurred

    var appEventOccurredExtrasFromCallsCount = 0
    var appEventOccurredExtrasFromCalled: Bool {
        return appEventOccurredExtrasFromCallsCount > 0
    }

    var appEventOccurredExtrasFromReceivedArguments: (event: String, extras: [String: Any]?, file: String)?
    var appEventOccurredExtrasFromReceivedInvocations: [(event: String, extras: [String: Any]?, file: String)] = []
    var appEventOccurredExtrasFromClosure: ((String, [String: Any]?, String) -> Void)?

    func appEventOccurred(_ event: String, extras: [String: Any]?, from file: String) {
        mockCalled = true
        appEventOccurredExtrasFromCallsCount += 1
        appEventOccurredExtrasFromReceivedArguments = (event: event, extras: extras, file: file)
        appEventOccurredExtrasFromReceivedInvocations.append((event: event, extras: extras, file: file))
        appEventOccurredExtrasFromClosure?(event, extras, file)
    }

    // MARK: - breadcrumb

    var breadcrumbExtrasFromCallsCount = 0
    var breadcrumbExtrasFromCalled: Bool {
        return breadcrumbExtrasFromCallsCount > 0
    }

    var breadcrumbExtrasFromReceivedArguments: (event: String, extras: [String: Any]?, file: String)?
    var breadcrumbExtrasFromReceivedInvocations: [(event: String, extras: [String: Any]?, file: String)] = []
    var breadcrumbExtrasFromClosure: ((String, [String: Any]?, String) -> Void)?

    func breadcrumb(_ event: String, extras: [String: Any]?, from file: String) {
        mockCalled = true
        breadcrumbExtrasFromCallsCount += 1
        breadcrumbExtrasFromReceivedArguments = (event: event, extras: extras, file: file)
        breadcrumbExtrasFromReceivedInvocations.append((event: event, extras: extras, file: file))
        breadcrumbExtrasFromClosure?(event, extras, file)
    }

    // MARK: - httpRequestEvent

    var httpRequestEventMethodUrlReqBodyCallsCount = 0
    var httpRequestEventMethodUrlReqBodyCalled: Bool {
        return httpRequestEventMethodUrlReqBodyCallsCount > 0
    }

    var httpRequestEventMethodUrlReqBodyReceivedArguments: (method: String, url: String, reqBody: String?)?
    var httpRequestEventMethodUrlReqBodyReceivedInvocations: [(method: String, url: String, reqBody: String?)] = []
    var httpRequestEventMethodUrlReqBodyClosure: ((String, String, String?) -> Void)?

    func httpRequestEvent(method: String, url: String, reqBody: String?) {
        mockCalled = true
        httpRequestEventMethodUrlReqBodyCallsCount += 1
        httpRequestEventMethodUrlReqBodyReceivedArguments = (method: method, url: url, reqBody: reqBody)
        httpRequestEventMethodUrlReqBodyReceivedInvocations.append((method: method, url: url, reqBody: reqBody))
        httpRequestEventMethodUrlReqBodyClosure?(method, url, reqBody)
    }

    // MARK: - httpSuccessEvent

    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount = 0
    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCalled: Bool {
        return httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount > 0
    }

    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments: (method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)?
    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations: [(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)] = []
    var httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyClosure: ((String, String, Int, String?, String?, String?) -> Void)?

    func httpSuccessEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        mockCalled = true
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount += 1
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments = (method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody)
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations.append((method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody))
        httpSuccessEventMethodUrlCodeReqHeadersResHeadersResBodyClosure?(method, url, code, reqHeaders, resHeaders, resBody)
    }

    // MARK: - httpFailEvent

    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount = 0
    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCalled: Bool {
        return httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount > 0
    }

    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments: (method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)?
    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations: [(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?)] = []
    var httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyClosure: ((String, String, Int, String?, String?, String?) -> Void)?

    func httpFailEvent(method: String, url: String, code: Int, reqHeaders: String?, resHeaders: String?, resBody: String?) {
        mockCalled = true
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyCallsCount += 1
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedArguments = (method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody)
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyReceivedInvocations.append((method: method, url: url, code: code, reqHeaders: reqHeaders, resHeaders: resHeaders, resBody: resBody))
        httpFailEventMethodUrlCodeReqHeadersResHeadersResBodyClosure?(method, url, code, reqHeaders, resHeaders, resBody)
    }

    // MARK: - errorOccurred

    var errorOccurredCallsCount = 0
    var errorOccurredCalled: Bool {
        return errorOccurredCallsCount > 0
    }

    var errorOccurredReceivedError: Error?
    var errorOccurredReceivedInvocations: [Error] = []
    var errorOccurredClosure: ((Error) -> Void)?

    func errorOccurred(_ error: Error) {
        mockCalled = true
        errorOccurredCallsCount += 1
        errorOccurredReceivedError = error
        errorOccurredReceivedInvocations.append(error)
        errorOccurredClosure?(error)
    }
}

class EventBusMock: EventBus {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - post

    var postExtrasCallsCount = 0
    var postExtrasCalled: Bool {
        return postExtrasCallsCount > 0
    }

    var postExtrasReceivedArguments: (event: EventBusEvent, extras: EventBusExtras?)?
    var postExtrasReceivedInvocations: [(event: EventBusEvent, extras: EventBusExtras?)] = []
    var postExtrasClosure: ((EventBusEvent, EventBusExtras?) -> Void)?

    func post(_ event: EventBusEvent, extras: EventBusExtras?) {
        mockCalled = true
        postExtrasCallsCount += 1
        postExtrasReceivedArguments = (event: event, extras: extras)
        postExtrasReceivedInvocations.append((event: event, extras: extras))
        postExtrasClosure?(event, extras)
    }

    // MARK: - register

    var registerEventCallsCount = 0
    var registerEventCalled: Bool {
        return registerEventCallsCount > 0
    }

    var registerEventReceivedArguments: (listener: EventBusEventListener, event: EventBusEvent)?
    var registerEventReceivedInvocations: [(listener: EventBusEventListener, event: EventBusEvent)] = []
    var registerEventClosure: ((EventBusEventListener, EventBusEvent) -> Void)?

    func register(_ listener: EventBusEventListener, event: EventBusEvent) {
        mockCalled = true
        registerEventCallsCount += 1
        registerEventReceivedArguments = (listener: listener, event: event)
        registerEventReceivedInvocations.append((listener: listener, event: event))
        registerEventClosure?(listener, event)
    }

    // MARK: - unregister

    var unregisterEventCallsCount = 0
    var unregisterEventCalled: Bool {
        return unregisterEventCallsCount > 0
    }

    var unregisterEventReceivedArguments: (listener: EventBusEventListener, event: EventBusEvent)?
    var unregisterEventReceivedInvocations: [(listener: EventBusEventListener, event: EventBusEvent)] = []
    var unregisterEventClosure: ((EventBusEventListener, EventBusEvent) -> Void)?

    func unregister(_ listener: EventBusEventListener, event: EventBusEvent) {
        mockCalled = true
        unregisterEventCallsCount += 1
        unregisterEventReceivedArguments = (listener: listener, event: event)
        unregisterEventReceivedInvocations.append((listener: listener, event: event))
        unregisterEventClosure?(listener, event)
    }

    // MARK: - unregisterAll

    var unregisterAllCallsCount = 0
    var unregisterAllCalled: Bool {
        return unregisterAllCallsCount > 0
    }

    var unregisterAllReceivedListener: EventBusEventListener?
    var unregisterAllReceivedInvocations: [EventBusEventListener] = []
    var unregisterAllClosure: ((EventBusEventListener) -> Void)?

    func unregisterAll(_ listener: EventBusEventListener) {
        mockCalled = true
        unregisterAllCallsCount += 1
        unregisterAllReceivedListener = listener
        unregisterAllReceivedInvocations.append(listener)
        unregisterAllClosure?(listener)
    }
}

class EventBusEventListenerMock: EventBusEventListener {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - eventBusEvent

    var eventBusEventExtrasCallsCount = 0
    var eventBusEventExtrasCalled: Bool {
        return eventBusEventExtrasCallsCount > 0
    }

    var eventBusEventExtrasReceivedArguments: (event: EventBusEvent, extras: EventBusExtras?)?
    var eventBusEventExtrasReceivedInvocations: [(event: EventBusEvent, extras: EventBusExtras?)] = []
    var eventBusEventExtrasClosure: ((EventBusEvent, EventBusExtras?) -> Void)?

    func eventBusEvent(_ event: EventBusEvent, extras: EventBusExtras?) {
        mockCalled = true
        eventBusEventExtrasCallsCount += 1
        eventBusEventExtrasReceivedArguments = (event: event, extras: extras)
        eventBusEventExtrasReceivedInvocations.append((event: event, extras: extras))
        eventBusEventExtrasClosure?(event, extras)
    }
}

class GitHubAPIMock: GitHubAPI {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - getUserRepos

    var getUserReposUsernameCallsCount = 0
    var getUserReposUsernameCalled: Bool {
        return getUserReposUsernameCallsCount > 0
    }

    var getUserReposUsernameReceivedUsername: String?
    var getUserReposUsernameReceivedInvocations: [String] = []
    var getUserReposUsernameReturnValue: Single<Result<[Repo], Error>>!
    var getUserReposUsernameClosure: ((String) -> Single<Result<[Repo], Error>>)?

    func getUserRepos(username: String) -> Single<Result<[Repo], Error>> {
        mockCalled = true
        getUserReposUsernameCallsCount += 1
        getUserReposUsernameReceivedUsername = username
        getUserReposUsernameReceivedInvocations.append(username)
        return getUserReposUsernameClosure.map { $0(username) } ?? getUserReposUsernameReturnValue
    }
}

class NotificationCenterManagerMock: NotificationCenterManager {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - post

    var postExtrasCallsCount = 0
    var postExtrasCalled: Bool {
        return postExtrasCallsCount > 0
    }

    var postExtrasReceivedArguments: (event: String, extras: [AnyHashable: Any]?)?
    var postExtrasReceivedInvocations: [(event: String, extras: [AnyHashable: Any]?)] = []
    var postExtrasClosure: ((String, [AnyHashable: Any]?) -> Void)?

    func post(_ event: String, extras: [AnyHashable: Any]?) {
        mockCalled = true
        postExtrasCallsCount += 1
        postExtrasReceivedArguments = (event: event, extras: extras)
        postExtrasReceivedInvocations.append((event: event, extras: extras))
        postExtrasClosure?(event, extras)
    }

    // MARK: - addObserver

    var addObserverSelectorNameCallsCount = 0
    var addObserverSelectorNameCalled: Bool {
        return addObserverSelectorNameCallsCount > 0
    }

    var addObserverSelectorNameReceivedArguments: (observer: Any, selector: Selector, name: String)?
    var addObserverSelectorNameReceivedInvocations: [(observer: Any, selector: Selector, name: String)] = []
    var addObserverSelectorNameClosure: ((Any, Selector, String) -> Void)?

    func addObserver(_ observer: Any, selector: Selector, name: String) {
        mockCalled = true
        addObserverSelectorNameCallsCount += 1
        addObserverSelectorNameReceivedArguments = (observer: observer, selector: selector, name: name)
        addObserverSelectorNameReceivedInvocations.append((observer: observer, selector: selector, name: name))
        addObserverSelectorNameClosure?(observer, selector, name)
    }

    // MARK: - removeObserver

    var removeObserverNameCallsCount = 0
    var removeObserverNameCalled: Bool {
        return removeObserverNameCallsCount > 0
    }

    var removeObserverNameReceivedArguments: (observer: Any, name: String)?
    var removeObserverNameReceivedInvocations: [(observer: Any, name: String)] = []
    var removeObserverNameClosure: ((Any, String) -> Void)?

    func removeObserver(_ observer: Any, name: String) {
        mockCalled = true
        removeObserverNameCallsCount += 1
        removeObserverNameReceivedArguments = (observer: observer, name: name)
        removeObserverNameReceivedInvocations.append((observer: observer, name: name))
        removeObserverNameClosure?(observer, name)
    }
}

class PendingTasksMock: PendingTasks {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - addDownloadNewFilesPendingTask

    var addDownloadNewFilesPendingTaskCallsCount = 0
    var addDownloadNewFilesPendingTaskCalled: Bool {
        return addDownloadNewFilesPendingTaskCallsCount > 0
    }

    var addDownloadNewFilesPendingTaskReturnValue: Double!
    var addDownloadNewFilesPendingTaskClosure: (() -> Double)?

    func addDownloadNewFilesPendingTask() -> Double {
        mockCalled = true
        addDownloadNewFilesPendingTaskCallsCount += 1
        return addDownloadNewFilesPendingTaskClosure.map { $0() } ?? addDownloadNewFilesPendingTaskReturnValue
    }

    // MARK: - runAllTasks

    var runAllTasksCallsCount = 0
    var runAllTasksCalled: Bool {
        return runAllTasksCallsCount > 0
    }

    var runAllTasksReturnValue: UIBackgroundFetchResult!
    var runAllTasksClosure: (() -> UIBackgroundFetchResult)?

    func runAllTasks() -> UIBackgroundFetchResult {
        mockCalled = true
        runAllTasksCallsCount += 1
        return runAllTasksClosure.map { $0() } ?? runAllTasksReturnValue
    }

    // MARK: - deleteAll

    var deleteAllCallsCount = 0
    var deleteAllCalled: Bool {
        return deleteAllCallsCount > 0
    }

    var deleteAllClosure: (() -> Void)?

    func deleteAll() {
        mockCalled = true
        deleteAllCallsCount += 1
        deleteAllClosure?()
    }
}

class ReposViewModelMock: ReposViewModel {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    var gitHubUsername: GitHubUsername?

    // MARK: - observeRepos

    var observeReposCallsCount = 0
    var observeReposCalled: Bool {
        return observeReposCallsCount > 0
    }

    var observeReposReturnValue: Observable<DataState<[Repo]>>!
    var observeReposClosure: (() -> Observable<DataState<[Repo]>>)?

    func observeRepos() -> Observable<DataState<[Repo]>> {
        mockCalled = true
        observeReposCallsCount += 1
        return observeReposClosure.map { $0() } ?? observeReposReturnValue
    }

    // MARK: - observeGitHubUsername

    var observeGitHubUsernameCallsCount = 0
    var observeGitHubUsernameCalled: Bool {
        return observeGitHubUsernameCallsCount > 0
    }

    var observeGitHubUsernameReturnValue: Observable<GitHubUsername>!
    var observeGitHubUsernameClosure: (() -> Observable<GitHubUsername>)?

    func observeGitHubUsername() -> Observable<GitHubUsername> {
        mockCalled = true
        observeGitHubUsernameCallsCount += 1
        return observeGitHubUsernameClosure.map { $0() } ?? observeGitHubUsernameReturnValue
    }
}

class RepositorySyncServiceMock: RepositorySyncService {
    var mockCalled: Bool = false // if *any* interactions done on mock. Sets/gets or methods called.

    // MARK: - syncAll

    var syncAllOnCompleteCallsCount = 0
    var syncAllOnCompleteCalled: Bool {
        return syncAllOnCompleteCallsCount > 0
    }

    var syncAllOnCompleteReceivedOnComplete: (([RefreshResult]) -> Void)?
    var syncAllOnCompleteReceivedInvocations: [([RefreshResult]) -> Void] = []
    var syncAllOnCompleteClosure: ((@escaping ([RefreshResult]) -> Void) -> Void)?

    func syncAll(onComplete: @escaping ([RefreshResult]) -> Void) {
        mockCalled = true
        syncAllOnCompleteCallsCount += 1
        syncAllOnCompleteReceivedOnComplete = onComplete
        syncAllOnCompleteReceivedInvocations.append(onComplete)
        syncAllOnCompleteClosure?(onComplete)
    }

    // MARK: - syncRepos

    var syncReposForceOnCompleteCallsCount = 0
    var syncReposForceOnCompleteCalled: Bool {
        return syncReposForceOnCompleteCallsCount > 0
    }

    var syncReposForceOnCompleteReceivedArguments: (force: Bool, onComplete: (RefreshResult) -> Void)?
    var syncReposForceOnCompleteReceivedInvocations: [(force: Bool, onComplete: (RefreshResult) -> Void)] = []
    var syncReposForceOnCompleteClosure: ((Bool, @escaping (RefreshResult) -> Void) -> Void)?

    func syncRepos(force: Bool, onComplete: @escaping (RefreshResult) -> Void) {
        mockCalled = true
        syncReposForceOnCompleteCallsCount += 1
        syncReposForceOnCompleteReceivedArguments = (force: force, onComplete: onComplete)
        syncReposForceOnCompleteReceivedInvocations.append((force: force, onComplete: onComplete))
        syncReposForceOnCompleteClosure?(force, onComplete)
    }
}
