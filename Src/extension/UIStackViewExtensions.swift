import Foundation
import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }

    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { subview in
            self.completelyRemoveArrangedSubview(subview)
        }
    }

    func completelyRemoveArrangedSubview(_ view: UIView?) {
        guard let view = view else {
            return
        }

        if arrangedSubviews.contains(view) {
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    func resistGrowingArrangedSubviews(for axis: NSLayoutConstraint.Axis) {
        arrangedSubviews.forEach { subview in
            subview.resistGrowing(for: axis)
        }
    }

    func resistShrinkingArrangedSubviews(for axis: NSLayoutConstraint.Axis) {
        arrangedSubviews.forEach { subview in
            subview.resistShrinking(for: axis)
        }
    }
}
