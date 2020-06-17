import Foundation

extension Array {
    mutating func insertOrLast(_ newElement: Element, at index: Int) {
        if index <= count {
            insert(newElement, at: index)
        } else {
            let lastIndex = count
            insert(newElement, at: lastIndex)
        }
    }
}

extension Array where Element: StringProtocol {
    func sortedNumbersAndStrings() -> [Element] {
        sorted { (lhs, rhs) -> Bool in
            lhs.localizedStandardCompare(rhs) == .orderedAscending
        }
    }
}
