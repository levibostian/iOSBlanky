@testable import App
import Foundation

extension EventBusMock {
    func postExtrasReceivedInvocationsOfType<Type: EventBusExtrasConverter>(for event: EventBusEvent) -> [Type] {
        postExtrasReceivedInvocations
            .filter { postEvent, _ in postEvent == event }
            .map { event, extras in extras!.get(for: event) }
    }
}
