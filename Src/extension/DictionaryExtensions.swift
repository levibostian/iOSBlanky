import Foundation

extension Dictionary where Key == AnyHashable, Value == Any {
    func toStringDictionary() -> [String: Any] {
        filter { (key, _) -> Bool in
            key is String
        } as! [String: Any] // swiftlint:disable:this force_cast
    }
}

extension Dictionary {
    func mapKeys<K: Hashable>(_ transform: (Key) -> K) -> [K: Value] {
        var newDictionary: [K: Value] = [:]

        forEach { arg0 in
            let (key, value) = arg0

            let newKey = transform(key)
            newDictionary[newKey] = value
        }

        return newDictionary
    }
}
