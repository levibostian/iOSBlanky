import Foundation

/**
 HTTP response code was 409
 */
struct ConflictResponseError: Codable {
    let message: String
    let errorId: String

    enum ErrorIdType {
        case phoneNumberTaken

        var raw: String {
            switch self {
            case .phoneNumberTaken: return "phone-number-taken"
            }
        }
    }

    var errorIdType: ErrorIdType? {
        switch errorId {
        case ErrorIdType.phoneNumberTaken.raw:
            return .phoneNumberTaken
        default: fatalError("forgot case for: \(errorId)")
        }
    }
}

extension ConflictResponseError: LocalizedError {
    var errorDescription: String? {
        localizedDescription
    }

    var localizedDescription: String {
        message
    }
}
