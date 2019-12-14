import Foundation
import UIKit

extension UIView {
    func resistShrinking(for axis: NSLayoutConstraint.Axis) {
        setContentHuggingPriority(.defaultLow, for: axis)
        setContentCompressionResistancePriority(.defaultHigh, for: axis)
    }

    func resistGrowing(for axis: NSLayoutConstraint.Axis) {
        setContentHuggingPriority(.defaultHigh, for: axis)
        setContentCompressionResistancePriority(.defaultLow, for: axis)
    }
}
