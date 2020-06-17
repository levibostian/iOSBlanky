import Foundation
import PleaseHold

public struct DarkModeEnabledPleaseHoldViewConfigPreset: PleaseHoldViewConfigPreset {
    public var titleLabel: UILabel {
        let label = PleaseHoldViewConfig.defaultTitleLabel
        label.textColor = Colors.textColor.color
        return label
    }

    public var messageLabel: UILabel {
        let label = PleaseHoldViewConfig.defaultMessageLabel
        label.textColor = Colors.textColor.color
        return label
    }

    public var activityIndicator: UIActivityIndicatorView {
        let indicator = PleaseHoldViewConfig.defaultActivityIndicator
        indicator.style = .gray
        return indicator
    }
}
