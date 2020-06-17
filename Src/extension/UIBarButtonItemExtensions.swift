import Foundation
import UIKit

extension UIBarButtonItem {
    // Construct a bar button item that is an image with some set defaults. Just using the real color of the image and a set size of the icon.
    // Help from: https://stackoverflow.com/a/53454225/1486374
    static func image(_ target: Any?, action: Selector, image: UIImage) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(image.notTinted(), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true

        return menuBarItem
    }
}
