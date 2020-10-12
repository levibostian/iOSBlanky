import Foundation
import SnapKit
import UIKit

class TextHeaderTableViewHeaderView: UITableViewHeaderFooterView {
    let titleLabel: UILabel = {
        let view = UILabel()
        view.setStyle(.h3)
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

        contentView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(18)
        }
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
    }

    func setTitle(_ titleText: String) {
        titleLabel.text = titleText
    }
}
