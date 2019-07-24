import Foundation
import UIKit

extension UIControl {
    func removeAllTargets() {
        removeTarget(nil, action: nil, for: .allEvents)
    }

    // UIControl does not have a "setTarget" you can only add more and more targets. This 1 function will make sure only 1 target is set.
    func setTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        removeAllTargets()
        addTarget(target, action: action, for: controlEvents)
    }
}
