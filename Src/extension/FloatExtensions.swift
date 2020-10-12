import Foundation

extension Float {
    /**
     Example: 4.1 -> 5, 4.9 -> 5
     */
    var roundUp: Int {
        Int(String(String(self + 1).split(separator: ".")[0]))!
    }

    /**
     Example: 4.1 -> 4, 4.9 -> 4
     */
    var roundDown: Int {
        Int(String(String(self).split(separator: ".")[0]))!
    }
}
