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
}
