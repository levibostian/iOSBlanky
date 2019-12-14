import Foundation
@testable import iOSBlanky
import XCTest

class NotificationCenterEventBusIntegrationTests: XCTestCase {
    var listener: EventBusEventListenerMock!
    var eventBus: NotificationCenterEventBus!
    var loggerMock: ActivityLoggerMock!

    let defaultEvent = EventBusEvent.logout

    override func setUp() {
        listener = EventBusEventListenerMock()
        loggerMock = ActivityLoggerMock()

        eventBus = NotificationCenterEventBus(notificationCenter: DI.shared.notificationCenterManager, activityLogger: loggerMock)
    }

    override func tearDown() {
        NotificationCenter.default.removeObserver(eventBus!)

        super.tearDown()
    }

    func test_registerAndPostEvent_expectGetNotifiedAboutEvent() {
        eventBus.register(listener, event: defaultEvent)

        let expectListenerToRecieveEvent = expectation(description: "Expect listener to get event")

        listener.eventBusEventExtrasClosure = { _, _ in
            XCTAssertEqual(self.listener.eventBusEventExtrasCallsCount, 1)
            XCTAssertEqual(self.listener.eventBusEventExtrasReceivedInvocations[0].event, self.defaultEvent)
            XCTAssertNil(self.listener.eventBusEventExtrasReceivedInvocations[0].extras)

            expectListenerToRecieveEvent.fulfill()
        }

        eventBus.post(defaultEvent, extras: nil)

        waitForExpectations()
    }

    func test_registerThenPostForDifferentEvent_expectDoNotGetNotified() {
        let registeredEvent = EventBusEvent.fileDownloaded
        let postEvent = EventBusEvent.logout

        eventBus.register(listener, event: registeredEvent)

        eventBus.post(postEvent, extras: nil)

        XCTAssertFalse(listener.eventBusEventExtrasCalled)
    }

    func test_registerAndPostEvent_listenerDeinit_expectDoNotGetNotified() {
        var listener: EventBusEventListenerMock? = EventBusEventListenerMock()

        eventBus.register(listener!, event: defaultEvent)

        listener = nil

        eventBus.post(defaultEvent, extras: nil)

        XCTAssertNil(listener)
        XCTAssertFalse(listener?.eventBusEventExtrasCalled ?? false)
    }

    func test_registerThenUnregister_postEvent_expectDoNotGetNotified() {
        eventBus.register(listener, event: defaultEvent)
        eventBus.unregister(listener, event: defaultEvent)

        eventBus.post(defaultEvent, extras: nil)

        XCTAssertFalse(listener.eventBusEventExtrasCalled)
    }

    func test_registerMultipleEvents_postEachEvent_expectGetNotifiedForEachEvent() {
        let event1 = EventBusEvent.logout
        let event2 = EventBusEvent.fileDownloaded

        eventBus.register(listener, event: event1)
        eventBus.register(listener, event: event2)

        let expectListenerCalled = expectation(description: "Expect listener gets called")
        expectListenerCalled.expectedFulfillmentCount = 2

        listener.eventBusEventExtrasClosure = { _, _ in
            expectListenerCalled.fulfill()
        }

        eventBus.post(event1, extras: nil)
        eventBus.post(event2, extras: nil)

//        waitForExpectations()
        waitForExpectations(timeout: 1.0, handler: nil)

        XCTAssertEqual(listener.eventBusEventExtrasCallsCount, 2)
        XCTAssertEqual(listener.eventBusEventExtrasReceivedInvocations[0].event, event1)
        XCTAssertEqual(listener.eventBusEventExtrasReceivedInvocations[1].event, event2)
        XCTAssertNil(listener.eventBusEventExtrasReceivedInvocations[0].extras)
        XCTAssertNil(listener.eventBusEventExtrasReceivedInvocations[1].extras)
    }

    func test_registerMultipleEvents_unregisterAll_expectDoNotNotified() {
        let event1 = EventBusEvent.logout
        let event2 = EventBusEvent.fileDownloaded

        eventBus.register(listener, event: event1)
        eventBus.register(listener, event: event2)

        eventBus.unregisterAll(listener)

        eventBus.post(event1, extras: nil)
        eventBus.post(event2, extras: nil)

        XCTAssertFalse(listener.eventBusEventExtrasCalled)
    }
}
