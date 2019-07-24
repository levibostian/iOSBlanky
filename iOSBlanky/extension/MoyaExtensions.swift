import Foundation
import Moya

typealias MoyaInstance = MoyaProvider<MultiTarget>

extension Response {
    func isSucccessfulResponse() -> Bool {
        return statusCode >= 200 && statusCode < 300
    }
}
