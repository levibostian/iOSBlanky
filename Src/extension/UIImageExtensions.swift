import Foundation
import UIKit

extension UIImage {
    convenience init?(contentsOf: URL) throws {
        let data = try Data(contentsOf: contentsOf)

        self.init(data: data)
    }

    func notTinted() -> UIImage {
        withRenderingMode(.alwaysOriginal)
    }
}
