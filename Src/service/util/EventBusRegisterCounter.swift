import Foundation

class EventBusRegisterCounter {
    private let counter = AtomicCounterCollection<EventBusEvent>()
    private let eventBus: EventBus

    weak var listener: EventBusEventListener? {
        didSet {
            reset()
        }
    }

    private var assertListener: EventBusEventListener? {
        guard let listener = self.listener else {
            reset()
            return nil
        }

        return listener
    }

    init(eventBus: EventBus) {
        self.eventBus = eventBus
    }

    private func reset() {
        counter.clear()
    }

    func register(event: EventBusEvent) {
        if let listener = assertListener {
            eventBus.register(listener, event: event)

            _ = counter.increment(for: event)
        }
    }

    func unregisterAll() {
        if let listener = assertListener {
            reset()
            eventBus.unregisterAll(listener)
        }
    }

    func unregister(event: EventBusEvent) {
        if let listener = assertListener {
            if try! counter.decrement(for: event) == 0 {
                eventBus.unregister(listener, event: event)
            }
        }
    }
}
