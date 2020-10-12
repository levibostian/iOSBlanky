import Foundation
import UIKit

struct AttributedTextBuilder {
    let attributed: NSMutableAttributedString
    weak var label: UILabel? // exists to reference values from.
    init(text: String, uiLabel: UILabel) {
        self.label = uiLabel
        self.attributed = NSMutableAttributedString(string: text)
    }

    func strikeThrough(width: Int = 2, range: Range<Int>? = nil) -> AttributedTextBuilder {
        var attributeRange = NSRange(location: 0, length: attributed.length)
        if let range = range {
            attributeRange = NSRange(range)
        }

        attributed.addAttribute(.strikethroughStyle, value: width, range: attributeRange)

        return self
    }

    /// `lineSpacing` this number is somewhat random. It doesn't match exactly what Sketch app says for the line spacing
    func paragraph(lineSpacing: CGFloat = 12, range: Range<Int>? = nil) -> AttributedTextBuilder {
        guard let label = self.label else {
            return self
        }

        let paragraphStyle = NSMutableParagraphStyle()

        if label.textAlignment == .center {
            paragraphStyle.alignment = .center
        } else if label.textAlignment == .right {
            paragraphStyle.alignment = .right
        } else {
            paragraphStyle.alignment = .left
        }

        var attributeRange = NSRange(location: 0, length: attributed.length)
        if let range = range {
            attributeRange = NSRange(range)
        }

        paragraphStyle.lineSpacing = lineSpacing
        attributed.addAttribute(.paragraphStyle, value: paragraphStyle, range: attributeRange)

        return self
    }
}
