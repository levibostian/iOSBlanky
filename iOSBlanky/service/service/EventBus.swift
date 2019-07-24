import Foundation

typealias EventBusExtras = [AnyHashable: Any]

enum EventBusEvent {
    case logout
}

extension EventBusEvent {
    var name: String {
        switch self {
        case .logout: return "logout"
        }
    }
}

protocol EventBus {
    func post(_ event: EventBusEvent, extras: EventBusExtras?)
}

class NotificationCenterEventBus: EventBus {
    func post(_ event: EventBusEvent, extras: EventBusExtras? = nil) {
        post(event.name, extras: extras)
    }

    fileprivate func post(_ name: String, extras: EventBusExtras?) {
        NotificationCenter.default.post(name: NSNotification.Name(name), object: nil, userInfo: extras)
    }
}
