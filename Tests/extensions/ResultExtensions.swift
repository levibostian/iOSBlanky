import Foundation

extension Result {
    var failure: Error? {
        switch self {
        case .failure(let error):
            return error
        default: return nil
        }
    }
}
