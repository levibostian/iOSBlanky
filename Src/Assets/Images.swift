import Foundation
import UIKit

enum Images: String, CaseIterable {
    case more
    case imagePlaceholder
}

extension Images {
    var image: UIImage {
        let key: String = rawValue

        let bundle = DI.shared.bundle

        return UIImage(named: key, in: bundle, compatibleWith: nil)! // swiftlint:disable:this use_images_enum
    }
}
