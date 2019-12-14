import Foundation
import UIKit

extension UITableView {
    func dequeueCell<R: UITableViewCell>(withIdentifier identifier: String, for indexPath: IndexPath) -> R {
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! R // swiftlint:disable:this force_cast
    }

    func cell<R: UITableViewCell>(at: IndexPath) -> R? {
        return cellForRow(at: at) as? R
    }
}
