import Foundation

typealias EventBusExtras = [String: Any]

@objc enum EventBusEvent: Int, CaseIterable {
    case logout
    case fileDownloaded

    static func fromName(_ name: String) -> EventBusEvent? {
        var returnEvent: EventBusEvent?

        allCases.forEach { event in
            if name == event.name {
                returnEvent = event
            }
        }

        return returnEvent
    }

    var name: String {
        switch self {
        case .logout: return "logout"
        case .fileDownloaded: return "fileDownloaded"
        }
    }
}

@objc protocol EventBusEventListener: AutoMockable {
    func eventBusEvent(_ event: EventBusEvent, extras: EventBusExtras?)
}

// would be nice if eventbus used the UI thread for calling listener functions. However, it needs to use a queue for all operations. Or else, you stand the chance of this sequence:
/**
 1. register listener
 2. on background thread: event posted. scheduled for main thread listener calling.
 3. still on background thread: unregister listener
 4. previously scheduled UI thread post, finally runs. But, listener doesn't get called because unregistered.
 */
protocol EventBus: AutoMockable {
    func post(_ event: EventBusEvent, extras: EventBusExtras?)
    // listener gets called on whatever thread post() was called on. It's up to you to switch to UI if you need it.
    func register(_ listener: EventBusEventListener, event: EventBusEvent)
    func unregister(_ listener: EventBusEventListener, event: EventBusEvent)
    func unregisterAll(_ listener: EventBusEventListener)
}

class NotificationCenterEventBus: EventBus {
    private var listeners: [EventBusEvent: NSHashTable<EventBusEventListener>] = [:]
    private let dispatch = DispatchQueue(label: "NotificationCenterEventBus")

    private let notificationCenter: NotificationCenterManager
    private let activityLogger: ActivityLogger

    init(notificationCenter: NotificationCenterManager, activityLogger: ActivityLogger) {
        self.notificationCenter = notificationCenter
        self.activityLogger = activityLogger
    }

    func post(_ event: EventBusEvent, extras: EventBusExtras?) {
        activityLogger.breadcrumb("posting event: \(event.name)", extras: extras)

        notificationCenter.post(event.name, extras: extras)
    }

    func register(_ listener: EventBusEventListener, event: EventBusEvent) {
        activityLogger.breadcrumb("listener registered for event: \(event.name)", extras: nil)

        dispatch.sync {
            var registerListener = false

            if listeners[event] == nil {
                listeners[event] = NSHashTable.weakObjects()

                registerListener = true
            }

            if !listeners[event]!.contains(listener) {
                if listeners[event]!.count <= 0 {
                    registerListener = true
                }

                listeners[event]!.add(listener)
            }

            if registerListener {
                notificationCenter.addObserver(self, selector: #selector(notificationFromNotificationCenter), name: event.name)
            }
        }
    }

    func unregister(_ listener: EventBusEventListener, event: EventBusEvent) {
        activityLogger.breadcrumb("listener unregistered for event: \(event.name)", extras: nil)

        dispatch.sync {
            listeners[event]?.remove(listener)

            // if listeners not null and count is 0, we just removed the last entry. So, remove.
            if listeners[event] != nil, listeners[event]!.count <= 0 {
                notificationCenter.removeObserver(self, name: event.name)
            }
        }
    }

    func unregisterAll(_ listener: EventBusEventListener) {
        listeners.forEach { event, _ in
            self.unregister(listener, event: event)
        }
    }

    @objc func notificationFromNotificationCenter(notification: NSNotification) {
        activityLogger.breadcrumb("notification center notification here!", extras: [
            "notification": notification.name
        ])

        guard let eventName = EventBusEvent.fromName(notification.name.rawValue) else {
            return
        }

        let eventListeners = dispatch.sync { () -> NSHashTable<EventBusEventListener>? in
            self.listeners[eventName]
        }

        eventListeners?.allObjects.forEach { eventBusListener in
            eventBusListener.eventBusEvent(eventName, extras: notification.userInfo?.toStringDictionary())
        }
    }
}

protocol NotificationCenterManager: AutoMockable {
    func post(_ event: String, extras: [AnyHashable: Any]?)
    func addObserver(_ observer: Any, selector: Selector, name: String)
    func removeObserver(_ observer: Any, name: String)
}

class AppNotificationCenterManager: NotificationCenterManager {
    private let notificationCenter = NotificationCenter.default

    func post(_ event: String, extras: [AnyHashable: Any]?) {
        notificationCenter.post(name: NSNotification.Name(rawValue: event), object: nil, userInfo: extras)
    }

    func addObserver(_ observer: Any, selector: Selector, name: String) {
        notificationCenter.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }

    func removeObserver(_ observer: Any, name: String) {
        notificationCenter.removeObserver(observer, name: NSNotification.Name(rawValue: name), object: nil)
    }
}
