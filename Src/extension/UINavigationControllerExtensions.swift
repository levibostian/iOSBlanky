import Foundation
import UIKit

extension UINavigationController {
    func makeTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default) // UIImage.init(named: "transparent.png")
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = .clear
        navigationBar.backgroundColor = .clear
    }
}
