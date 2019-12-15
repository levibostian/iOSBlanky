import Foundation
import UIKit

enum Colors: String, CaseIterable {
    case backgroundColor
    case textColor
    case buttonColor
    case navigationBarColor
}

extension Colors {
    var color: UIColor {
        let key: String = rawValue

        let bundle = DI.shared.bundle

        return UIColor(named: key, in: bundle, compatibleWith: nil)!
    }
}
