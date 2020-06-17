import Foundation
import Kingfisher
import UIKit

/**
 Wrapper around Kingfisher so there is only 1 place that we need to maintain the API for loading images into ImageView.
 */
class RemoteImageView: UIImageView {
    private var viewIsShown = true // important to make sure the view has been measured

    var url: URL? {
        didSet {
            setImageIfReady()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        viewIsShown = true
        setImageIfReady()
    }

    convenience init() {
        self.init(frame: CGRect.zero)

        build()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        build()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func build() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }

    private func setImageIfReady() {
        guard viewIsShown else {
            return
        }

        if let url = self.url {
            kf.setImage(with: url, placeholder: Images.imagePlaceholder.image)
        }
    }
}
