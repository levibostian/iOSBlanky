import Foundation
import UIKit

enum UILabelStyle {
    case h1
    case h2
    case h2_light
    case h3
    case h3_light
    case h4
    case h4_light
    case p
    case p_light
    case p_light_italics
    case hint_gray
    case hint_primaryColor
}

extension UILabel {
    // All of these styles come directly from the digital design created.
    func setStyle(_ style: UILabelStyle) {
        lineBreakMode = .byWordWrapping
        numberOfLines = 0

        switch style {
        case .h1:
            font = UIFont.get(font: .bold, size: 48)
            textColor = Colors.primaryTextColor.color
            textAlignment = .center
        case .h2:
            font = UIFont.get(font: .bold, size: 36)
            textColor = Colors.primaryTextColor.color
            textAlignment = .center
        case .h2_light:
            font = UIFont.get(font: .bold, size: 36)
            textColor = Colors.primaryTextColor.color
            textAlignment = .center
        case .h3:
            font = UIFont.get(font: .bold, size: 24)
            textColor = Colors.primaryTextColor.color
            textAlignment = .center
        case .h3_light:
            font = UIFont.get(font: .regular, size: 24)
            textColor = Colors.primaryTextColor.color
            textAlignment = .center
        case .h4:
            font = UIFont.get(font: .regular, size: 18)
            textColor = Colors.primaryTextColor.color
            textAlignment = .left
        case .h4_light:
            font = UIFont.get(font: .regular, size: 18)
            textColor = Colors.primaryTextColor.color
            textAlignment = .left
        case .p:
            font = UIFont.get(font: .thin, size: 14)
            textColor = Colors.primaryTextColor.color
            textAlignment = .left
        case .p_light:
            font = UIFont.get(font: .thin, size: 14)
            textColor = Colors.primaryTextColor.color
            textAlignment = .left
        case .p_light_italics:
            font = UIFont.get(font: .thin, size: 14)
            textColor = Colors.primaryTextColor.color
            textAlignment = .left
        case .hint_gray:
            font = UIFont.systemFont(ofSize: 12)
            textColor = Colors.primaryTextColor.color
            textAlignment = .left
        case .hint_primaryColor:
            font = UIFont.systemFont(ofSize: 12)
            textColor = Colors.primaryTextColor.color
            textAlignment = .left
        }
    }

    // Set text but will include paragraph line height
    var textParagraph: String? {
        get {
            text
        }
        set {
            guard let newText = newValue else {
                text = nil
                return
            }

            let attributedString = NSMutableAttributedString(string: newText)
            let paragraphStyle = NSMutableParagraphStyle()

            if textAlignment == .center {
                paragraphStyle.alignment = .center
            } else if textAlignment == .right {
                paragraphStyle.alignment = .right
            } else {
                paragraphStyle.alignment = .left
            }

            paragraphStyle.lineSpacing = 12 // this number is somewhat random. It doesn't match exactly what Sketch app says for the line spacing
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

            attributedText = attributedString
        }
    }

    var textOrHide: String? {
        get {
            text
        }
        set {
            text = newValue

            isHidden = newValue == nil
        }
    }

    var isStrikethrough: Bool {
        guard let attributedText = attributedText else {
            return false
        }

        return attributedText.attributes(at: 0, effectiveRange: nil).contains { $0.key == .strikethroughStyle }
    }

    // Convenient way to apply attributed text to a UILabel using the builder design pattern. Easier to use API then NSMutableAttributedString() and you can use 1+ attributes to a label.
    func textStyled(_ text: String? = nil, _ build: (AttributedTextBuilder) -> AttributedTextBuilder) {
        attributedText = build(AttributedTextBuilder(text: text ?? self.text ?? "", uiLabel: self)).attributed
    }
}
