import Foundation

extension Collection {
    // Thanks, https://stackoverflow.com/a/30593673/1486374
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element: Any {
    mutating func removeFirstOrNil() -> Element? {
        if !isEmpty {
            return removeFirst()
        } else {
            return nil
        }
    }
}
