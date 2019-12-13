import Foundation

extension Dictionary where Key == AnyHashable, Value == Any {
    func toStringDictionary() -> [String: Any] {
        return filter { (key, _) -> Bool in
            key is String
        } as! [String: Any] // swiftlint:disable:this force_cast
    }
}
