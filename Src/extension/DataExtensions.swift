import Foundation

extension Data {
    func string() -> String {
        return String(data: self, encoding: .utf8)!
    }
}
