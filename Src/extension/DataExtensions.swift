import Foundation

extension Data {
    func string() -> String {
        String(data: self, encoding: .utf8)!
    }
}
