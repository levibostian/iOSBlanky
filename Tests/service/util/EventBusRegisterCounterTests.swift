import Foundation
@testable import iOSBlanky
import XCTest

class EventBusRegisterCounterTests: XCTestCase {
    private var eventBusRegisterCounter: EventBusRegisterCounter!
    private var eventBusMock: EventBusMock!
    private var listener: EventBusEventListenerMock!

    override func setUp() {
        super.setUp()

        eventBusMock = EventBusMock()
        listener = EventBusEventListenerMock()

        eventBusRegisterCounter = EventBusRegisterCounter(eventBus: eventBusMock)
        eventBusRegisterCounter.listener = listener
    }

    override func tearDown() {
        TestUtil.tearDown()

        super.tearDown()
    }

    func test_register_expectEventBusRegisterForEvent() {
        let expectedEvent = EventBusEvent.logout
        eventBusRegisterCounter.register(event: expectedEvent)

        XCTAssertEqual(eventBusMock.registerEventCallsCount, 1)

        let actualEvent = eventBusMock.registerEventReceivedArguments!.event
        XCTAssertEqual(expectedEvent, actualEvent)
    }

    func test_register_givenNilListener_expectIgnoreRequest() {
        listener = nil

        eventBusRegisterCounter.register(event: .logout)

        XCTAssertFalse(eventBusMock.mockCalled)
    }

    func test_unregisterAll_givenNoRegistering_expectUnregisterAll() {
        eventBusRegisterCounter.unregisterAll()

        XCTAssertEqual(eventBusMock.unregisterAllCallsCount, 1)
    }

    func test_unregisterAll_givenManyRegistrations_expectUnregisterAll() {
        eventBusRegisterCounter.register(event: .logout)
        eventBusRegisterCounter.register(event: .logout)
        eventBusRegisterCounter.unregisterAll()

        XCTAssertEqual(eventBusMock.unregisterAllCallsCount, 1)
    }

    func test_unregisterAll_givenNilListener_expectIgnoreRequest() {
        listener = nil

        eventBusRegisterCounter.unregisterAll()

        XCTAssertFalse(eventBusMock.mockCalled)
    }

    func test_unregister_givenOneRegistration_expectUnregister() {
        let event = EventBusEvent.logout

        eventBusRegisterCounter.register(event: event)
        eventBusRegisterCounter.unregister(event: event)

        XCTAssertEqual(eventBusMock.unregisterEventCallsCount, 1)
    }

    func test_unregister_givenMultipleRegistrations_expectNoUnregistering() {
        let event = EventBusEvent.logout

        eventBusRegisterCounter.register(event: event)
        eventBusRegisterCounter.register(event: event)
        eventBusRegisterCounter.unregister(event: event)

        XCTAssertFalse(eventBusMock.unregisterEventCalled)
    }

    func test_unregister_givenNilListener_expectIgnoreRequest() {
        eventBusRegisterCounter.register(event: .logout)
        eventBusRegisterCounter.listener = nil

        eventBusRegisterCounter.unregister(event: .logout)

        XCTAssertFalse(eventBusMock.unregisterEventCalled)
    }

    func test_setNewListener_expectRegisterAndUnregisterWorkingBecauseCounterCleared() {
        let event = EventBusEvent.logout

        // given registering multiple times so if I call unregister once, it should not unregister
        eventBusRegisterCounter.register(event: event)
        eventBusRegisterCounter.register(event: event)

        let newListener = EventBusEventListenerMock()

        eventBusRegisterCounter.listener = newListener

        // now, registering and unregistering once, will only work if counter reset
        eventBusRegisterCounter.register(event: event)
        eventBusRegisterCounter.unregister(event: event)

        XCTAssertEqual(eventBusMock.unregisterEventCallsCount, 1)
    }
}
