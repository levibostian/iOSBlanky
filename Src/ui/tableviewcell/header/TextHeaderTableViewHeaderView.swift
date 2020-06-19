import Foundation
import SnapKit
import UIKit

class TextHeaderTableViewHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = "TextHeaderTableViewHeaderViewId"

    fileprivate var didSetupConstraints = false

    let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = Colors.textColor.color
        view.font = UIFont.get(font: .bold, size: 24)
        view.numberOfLines = 0
        return view
    }()

    convenience init() {
        self.init(reuseIdentifier: nil)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        build()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        build()
    }

    private func build() {
        clearBackground()

        contentView.addSubview(titleLabel)

        contentView.setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        if !didSetupConstraints {
            contentView.snp.makeConstraints { make in
                make.size.equalToSuperview()
            }
            titleLabel.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(24)
                make.top.bottom.equalToSuperview().inset(18)
            }
            titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)

            didSetupConstraints = true
        }
        super.updateConstraints()
    }

    func setTitle(_ titleText: String) {
        titleLabel.text = titleText
    }
}
