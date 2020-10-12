import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

    mutating func insertOrLast(_ newElement: Element, at index: Int) {
        if index <= count {
            insert(newElement, at: index)
        } else {
            let lastIndex = count
            insert(newElement, at: lastIndex)
        }
    }

    mutating func forEachEdit(_ handler: (Element) -> Element) {
        for (index, element) in enumerated() {
            let newElement = handler(element)

            self[index] = newElement
        }
    }

    func forEachIndex(_ handler: ((element: Element, index: Int)) -> Void) {
        for (index, element) in enumerated() {
            handler((element: element, index: index))
        }
    }

    var isOddCount: Bool {
        !isEvenCount
    }

    var isEvenCount: Bool {
        count % 2 == 0
    }

    /**
     if odd count array, returns element in middle.
     if even count array, use the `evenRoundDownMiddle` parameter to determine if we round up or down for the middle.
     */
    func middleElement(evenRoundDownMiddle: Bool) -> Element? {
        guard !isEmpty else {
            return nil
        }

        if isOddCount {
            let index = Float(count / 2).roundDown
            return self[index]
        } else {
            let index = count / 2

            if evenRoundDownMiddle {
                return self[index - 1]
            } else {
                return self[index]
            }
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
