import Foundation
import UIKit

extension UITableViewHeaderFooterView {
    func clearBackground() {
        backgroundView = UIView()
        backgroundView!.backgroundColor = .clear
    }
}
