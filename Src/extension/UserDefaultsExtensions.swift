import Foundation
import UIKit

extension UserDefaults {
    func deleteAll() {
        dictionaryRepresentation().keys.forEach { removeObject(forKey: $0) }
    }

    var keys: [String] {
        dictionaryRepresentation().keys.map { String($0) }
    }
}
