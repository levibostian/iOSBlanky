import Foundation
import UIKit

extension UITableView {
    func dequeueCell<R: UITableViewCell>(withIdentifier identifier: String, for indexPath: IndexPath) -> R {
        dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! R // swiftlint:disable:this force_cast
    }

    func dequeueHeaderFooterView<R: UITableViewHeaderFooterView>(withIdentifier identifier: String) -> R {
        dequeueReusableHeaderFooterView(withIdentifier: identifier) as! R // swiftlint:disable:this force_cast
    }

    func cell<R: UITableViewCell>(at: IndexPath) -> R? {
        cellForRow(at: at) as? R
    }
}
