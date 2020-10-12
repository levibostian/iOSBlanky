import Foundation
import UIKit

extension UIView {
    var x: CGFloat {
        frame.origin.x
    }

    var y: CGFloat {
        frame.origin.y
    }

    // Note: Button touch listeners will not work when you make the view invisible.
    var isInvisible: Bool {
        get {
            alpha <= 0.0
        }
        set {
            let makeInvisible = newValue

            alpha = makeInvisible ? 0.0 : 1.0
        }
    }

    var isShown: Bool {
        get {
            !isHidden && superview != nil
        }
        set {
            isHidden = !newValue
        }
    }

    // If you want to adding some padding to the inside of a view. Sometimes this is easier then trying to do it in AutoLayout
    // Thanks: https://useyourloaf.com/blog/adding-padding-to-a-stack-view/
    var internalPadding: EdgeMeasurements {
        get {
            directionalLayoutMargins.edgeMeasurements
        }
        set {
            directionalLayoutMargins = newValue.directionalEdgeInsets

            // Stackviews need this field so that is arranges subviews by the padding instead of edges.
            (self as? UIStackView)?.isLayoutMarginsRelativeArrangement = true
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
        let matchingViews = findViewsByAccessibilityIdentifier(identifier: identifier)

        if matchingViews.count > 1 {
            fatalError("\(matchingViews.count) Views found with ID: \(identifier), expected 1. Fix the issue or use another function to get all Views.")
        }

        return matchingViews[safe: 0]
    }

    func findViewsByAccessibilityIdentifier(identifier: AccessibilityIdentifier) -> [UIView] {
        var matchingViews: [UIView] = []

        func findByID(view: UIView, _ id: String) {
            if view.accessibilityIdentifier == id {
                matchingViews.append(view)
            }
            for subview in view.subviews {
                findByID(view: subview, id)
            }
        }

        findByID(view: self, identifier)

        return matchingViews
    }

    func addSubviews(_ viewsToAdd: [UIView]) {
        viewsToAdd.forEach { view in
            self.addSubview(view)
        }
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

    // Views usually do not have touch listeners on them. This is a way to make any view respond to being touched.
    func addTarget(_ target: Any?, action: Selector) {
        isUserInteractionEnabled = true

        let gesture = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(gesture)
    }
}

enum Corner {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

struct EdgeMeasurements {
    let left: CGFloat
    let top: CGFloat
    let right: CGFloat
    let bottom: CGFloat

    var directionalEdgeInsets: NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }

    var edgeInsets: UIEdgeInsets {
        UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }

    init(all: CGFloat) {
        self.left = all
        self.top = all
        self.right = all
        self.bottom = all
    }

    init(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) {
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }

    init(x: CGFloat, y: CGFloat) {
        self.left = x
        self.top = y
        self.right = x
        self.bottom = y
    }
}

extension NSDirectionalEdgeInsets {
    var edgeMeasurements: EdgeMeasurements {
        EdgeMeasurements(left: leading, top: top, right: trailing, bottom: bottom)
    }
}
