import Foundation

enum ErrorForTesting: Error, LocalizedError, Equatable {
    case foo
    case bar

    var errorDescription: String? {
        return localizedDescription
    }

    var localizedDescription: String {
        switch self {
        case .foo: return "foo"
        case .bar: return "bar"
        }
    }
}
