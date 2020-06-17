import Empty
import Foundation

public struct DarkModeEnabledEmptyViewConfig: EmptyViewConfigPreset {
    public var titleLabel: UILabel {
        let label = EmptyViewConfig.defaultTitleLabel
        label.textColor = Colors.textColor.color
        return label
    }

    public var messageLabel: UILabel {
        let label = EmptyViewConfig.defaultMessageLabel
        label.textColor = Colors.textColor.color
        return label
    }

    public var button: UIButton {
        let label = EmptyViewConfig.defaultButton
        label.setTitleColor(Colors.buttonColor.color, for: .normal)
        return label
    }
}
