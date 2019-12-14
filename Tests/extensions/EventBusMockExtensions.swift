import Foundation
@testable import iOSBlanky

extension EventBusMock {
    func postExtrasReceivedInvocationsOfType<Type: EventBusExtrasConverter>(for event: EventBusEvent) -> [Type] {
        return postExtrasReceivedInvocations
            .filter { postEvent, _ in postEvent == event }
            .map { event, extras in extras!.get(for: event) }
    }
}
