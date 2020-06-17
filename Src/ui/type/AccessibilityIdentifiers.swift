import Foundation

typealias AccessibilityIdentifier = String

extension Array where Element: RawRepresentable, Element.RawValue == AccessibilityIdentifier {
    var ids: [AccessibilityIdentifier] {
        map { $0.rawValue }
    }
}
