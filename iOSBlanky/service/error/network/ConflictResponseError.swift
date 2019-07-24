import Foundation

enum ErrorIdType {
    case phoneNumberTaken
}

/**
 HTTP response code was 409
 */
struct ConflictResponseError: Codable {
    let message: String
    let errorId: String

    var errorIdType: ErrorIdType? {
        switch errorId {
        case "phone-number-taken":
            return .phoneNumberTaken
        default: fatalError("forgot case for: \(errorId)")
        }
    }
}

extension ConflictResponseError: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
