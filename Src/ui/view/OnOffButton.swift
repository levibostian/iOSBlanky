import Foundation
import UIKit

class OnOffButton: UIButton {
    private let onImage: UIImage
    private let offImage: UIImage

    init(onImage: UIImage, offImage: UIImage) {
        self.onImage = onImage
        self.offImage = offImage

        super.init(frame: .zero)

        self.on = false
    }

    var on: Bool {
        get {
            image(for: .normal) == onImage
        }
        set {
            let isOn = newValue

            if isOn {
                setImage(onImage, for: .normal)
            } else {
                setImage(offImage, for: .normal)
            }
        }
    }

    convenience init() {
        self.init(frame: CGRect.zero)

        build()
    }

    override init(frame: CGRect) {
        self.onImage = UIImage()
        self.offImage = UIImage()

        super.init(frame: frame)

        build()
    }

    required init?(coder aDecoder: NSCoder) {
        self.onImage = UIImage()
        self.offImage = UIImage()

        super.init(coder: aDecoder)
    }

    private func build() {}
}
