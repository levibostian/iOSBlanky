import Foundation
@testable import iOSBlanky
import RxSwift
import XCTest

class NotificationCenterEventBusTests: XCTestCase {
    private var listenerMock: EventBusEventListenerMock!
    private var notificationCenterMock: NotificationCenterManagerMock!
    private var activityLoggerMock: ActivityLoggerMock!

    private var eventBus: NotificationCenterEventBus!

    private let defaultEvent = EventBusEvent.logout

    override func setUp() {
        super.setUp()

        listenerMock = EventBusEventListenerMock()
        notificationCenterMock = NotificationCenterManagerMock()
        activityLoggerMock = ActivityLoggerMock()

        eventBus = NotificationCenterEventBus(notificationCenter: notificationCenterMock, activityLogger: activityLoggerMock)
    }

    func test_post_expectCallWithArgs() {
        let givenEvent = defaultEvent
        let givenExtras: [String: Bool] = ["foo": true]

        eventBus.post(givenEvent, extras: givenExtras)

        XCTAssertEqual(notificationCenterMock.postExtrasCallsCount, 1)
        XCTAssertEqual(notificationCenterMock.postExtrasReceivedInvocations[0].event, givenEvent.name)
        XCTAssertEqual(notificationCenterMock.postExtrasReceivedInvocations[0].extras as! [String: Bool], givenExtras)
    }

    func test_register_firstListenerForEvent_expectStartListeningToEvent() {
        eventBus.register(listenerMock, event: defaultEvent)

        XCTAssertEqual(notificationCenterMock.addObserverSelectorNameCallsCount, 1)
    }

    func test_register_registerMultipleListenersSameEvent_expectStartListeningOnce() {
        let listener1 = EventBusEventListenerMock()
        let listener2 = EventBusEventListenerMock()

        eventBus.register(listener1, event: defaultEvent)
        eventBus.register(listener2, event: defaultEvent)

        XCTAssertEqual(notificationCenterMock.addObserverSelectorNameCallsCount, 1)
    }

    func test_register_registerListenersDifferentEvent_expectStartListeningForEachEvent() {
        let listener1 = EventBusEventListenerMock()
        let listener2 = EventBusEventListenerMock()

        let event1 = EventBusEvent.fileDownloaded
        let event2 = EventBusEvent.logout

        eventBus.register(listener1, event: event1)
        eventBus.register(listener2, event: event2)

        XCTAssertEqual(notificationCenterMock.addObserverSelectorNameCallsCount, 2)
        XCTAssertEqual(notificationCenterMock.addObserverSelectorNameReceivedInvocations[0].name, event1.name)
        XCTAssertEqual(notificationCenterMock.addObserverSelectorNameReceivedInvocations[1].name, event2.name)
    }

    func test_unregister_only1ListenerForEvent_expectNotificationCenterRemovedObserver() {
        eventBus.register(listenerMock, event: defaultEvent)
        eventBus.unregister(listenerMock, event: defaultEvent)

        XCTAssertEqual(notificationCenterMock.removeObserverNameCallsCount, 1)
        XCTAssertEqual(notificationCenterMock.removeObserverNameReceivedInvocations[0].name, defaultEvent.name)
    }

    func test_unregisterOnce_2ListenersForEvent_expectNotificationCenterRemovedObserver() {
        let listener1 = EventBusEventListenerMock()
        let listener2 = EventBusEventListenerMock()

        eventBus.register(listener1, event: defaultEvent)
        eventBus.register(listener2, event: defaultEvent)

        eventBus.unregister(listener1, event: defaultEvent)

        XCTAssertFalse(notificationCenterMock.removeObserverNameCalled)
    }

    func test_unregister_listenerNotRegistered_expectIgnoreRequest() {
        eventBus.unregister(listenerMock, event: defaultEvent)

        XCTAssertFalse(notificationCenterMock.mockCalled)
    }

    func test_unregisterAll_listenerNotRegistered_expectIgnoreRequest() {
        eventBus.unregisterAll(listenerMock)

        XCTAssertFalse(notificationCenterMock.mockCalled)
    }
}
