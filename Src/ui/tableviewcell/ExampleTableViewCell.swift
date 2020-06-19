import UIKit

class ExampleTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ExampleTableViewCellId"

    private var didSetupConstraints = false

    let cornerRadius = CGFloat(30.0)
    let spaceBetweenCells = 18

    var listItem: String? {
        didSet {
            if let listItem = listItem {
                populate(listItem)
            }
        }
    }

    lazy var productImage: RemoteImageView = {
        let view = RemoteImageView()
        return view
    }()

    let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = Colors.textColor.color
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.numberOfLines = 0
        return view
    }()

    let rootStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 12
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        rootStackView.addArrangedSubviews([
            productImage,
            titleLabel
        ])

        productImage.roundCorners(radius: cornerRadius, corners: [.topLeft, .bottomLeft])

        contentView.addSubview(rootStackView)

        contentView.setNeedsUpdateConstraints()

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupViews() {}

    override func updateConstraints() {
        if !didSetupConstraints {
            let minCellHeight = spaceBetweenCells + 110 // Must add cell padding for actual height.

            rootStackView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.greaterThanOrEqualTo(minCellHeight)
            }
            titleLabel.snp.makeConstraints { make in
                make.height.equalToSuperview()
            }
            titleLabel.resistShrinking(for: .vertical)
            titleLabel.resistShrinking(for: .horizontal)
            productImage.snp.makeConstraints { make in
                make.leading.equalTo(contentView.snp.leading)
                make.height.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.5)
            }
            productImage.resistShrinking(for: .vertical)
            productImage.resistGrowing(for: .horizontal)

            didSetupConstraints = true
        }
        super.updateConstraints()
    }

    private func populate(_ listItem: String) {
        setupViews()

        titleLabel.text = listItem
    }
}
