import Foundation

struct FieldsErrorResponse: Codable {
    let message: String
}

extension FieldsErrorResponse: LocalizedError {
    var errorDescription: String? {
        localizedDescription
    }

    var localizedDescription: String {
        message
    }
}
