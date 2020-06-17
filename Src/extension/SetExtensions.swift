import Foundation

extension Set {
    // help from: https://stackoverflow.com/a/48814217/1486374
    @discardableResult mutating func insert(_ newMembers: [Set.Element]) -> [(inserted: Bool, memberAfterInsert: Set.Element)] {
        var returnArray: [(inserted: Bool, memberAfterInsert: Set.Element)] = []
        newMembers.forEach { member in
            returnArray.append(self.insert(member))
        }
        return returnArray
    }

    // If need order, use a NSMutableOrderedSet
    var unorderedArray: [Element] {
        Array(self)
    }
}
