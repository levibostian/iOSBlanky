import Foundation
import UIKit

extension UICollectionView {
    func dequeueCell<R: UICollectionViewCell>(withIdentifier identifier: String, for indexPath: IndexPath) -> R {
        dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! R // swiftlint:disable:this force_cast
    }
}
