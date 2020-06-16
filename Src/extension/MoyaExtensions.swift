import Foundation
import Moya

extension Response {
    func isSucccessfulResponse() -> Bool {
        statusCode >= 200 && statusCode < 300
    }
}
