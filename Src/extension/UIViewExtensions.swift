import Foundation
import UIKit

extension UIView {
    var x: CGFloat {
        frame.origin.x
    }

    var y: CGFloat {
        frame.origin.y
    }

    var isShown: Bool {
        set {
            isHidden = !newValue
        }
        get {
            !isHidden && superview != nil
        }
    }

    func doNotResistShrinking(for axis: NSLayoutConstraint.Axis) {
        resistGrowing(for: axis)
    }

    func doNotResistGrowing(for axis: NSLayoutConstraint.Axis) {
        resistShrinking(for: axis)
    }

    func resistShrinking(for axis: NSLayoutConstraint.Axis) {
        setContentHuggingPriority(.defaultLow, for: axis)
        setContentCompressionResistancePriority(.defaultHigh, for: axis)
    }

    func resistGrowing(for axis: NSLayoutConstraint.Axis) {
        setContentHuggingPriority(.defaultHigh, for: axis)
        setContentCompressionResistancePriority(.defaultLow, for: axis)
    }

    var allSubviews: [UIView] {
        subviews + subviews.flatMap { $0.allSubviews }
    }

    func findByAccessibilityIdentifier(identifier: AccessibilityIdentifier) -> UIView? {
        func findByID(view: UIView, _ id: String) -> UIView? {
            if view.accessibilityIdentifier == id {
                return view
            }
            for subview in view.subviews {
                if let foundView = findByID(view: subview, id) {
                    return foundView
                }
            }
            return nil
        }

        return findByID(view: self, identifier)
    }

    func addSubview(_ view: UIView, constraints: [NSLayoutConstraint]) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }

    func roundCorners(radius: CGFloat, corners: [Corner]? = nil) {
        var transformedCorners: CACornerMask = []

        let corners = corners ?? [.topRight, .topLeft, .bottomRight, .bottomLeft]

        corners.forEach { corner in
            switch corner {
            case .topLeft: transformedCorners.insert(.layerMinXMaxYCorner)
            case .bottomLeft: transformedCorners.insert(.layerMinXMinYCorner)
            case .topRight: transformedCorners.insert(.layerMaxXMaxYCorner)
            case .bottomRight: transformedCorners.insert(.layerMaxXMinYCorner)
            }
        }

        layer.masksToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = transformedCorners
    }
}

enum Corner {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}
