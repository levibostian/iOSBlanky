import Foundation
import UIKit

extension UITableView {
    func dequeueCell<R: UITableViewCell>(for indexPath: IndexPath) -> R {
        dequeueReusableCell(withIdentifier: R.reuseIdentifier, for: indexPath) as! R // swiftlint:disable:this force_cast
    }

    func register<R: UITableViewCell>(_: R.Type) {
        register(R.self, forCellReuseIdentifier: R.reuseIdentifier)
    }

    func register<R: UITableViewHeaderFooterView>(_: R.Type) {
        register(R.self, forHeaderFooterViewReuseIdentifier: R.reuseIdentifier)
    }

    func dequeueHeaderFooterView<R: UITableViewHeaderFooterView>() -> R {
        dequeueReusableHeaderFooterView(withIdentifier: R.reuseIdentifier) as! R // swiftlint:disable:this force_cast
    }

    func cell<R: UITableViewCell>(at: IndexPath) -> R? {
        cellForRow(at: at) as? R
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
