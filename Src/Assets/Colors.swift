import Foundation
import UIKit

enum Colors: String, CaseIterable {
    case backgroundColor
    case tableViewCellBackgroundColor
    case primaryTextColor
    case buttonColor
    case navigationBarColor
    case navigationBarTintColor
    case pickerViewBackground
    case uiPageControlSelectedPageTintColor
    case uiPageControlNotSelectedPageTintColor
}

extension Colors {
    var color: UIColor {
        let key: String = rawValue

        let bundle = DI.shared.bundle

        return UIColor(named: key, in: bundle, compatibleWith: nil)!
    }
}
