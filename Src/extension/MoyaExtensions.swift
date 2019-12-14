import Foundation
import Moya

extension Response {
    func isSucccessfulResponse() -> Bool {
        return statusCode >= 200 && statusCode < 300
    }
}
