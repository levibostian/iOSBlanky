import Foundation

/**
 Convenient class that only allows you to create a dictionary with a finite amount of keys. Trying to insert elements of other keys will not be allowed.
 */
class KeyRangeDictionary<Key: Hashable, Value: Any> {
    private(set) var dictionary: OrderedDictionary<Key, Value> = [:]
    private var allowedKeys: [Key]!

    init<Range: Sequence>(range: Range, defaultValue: Value? = nil) where Range.Element == Key {
        self.allowedKeys = []

        allowedKeys.append(contentsOf: range)

        if let defaultValue = defaultValue {
            for key in range {
                dictionary.updateValue(defaultValue, forKey: key)
            }
        }
    }

    func set(_ key: Key, value: Value) {
        guard allowedKeys.contains(key) else {
            return
        }

        dictionary.updateValue(value, forKey: key)
    }
}
